package com.lingua.service;

import com.lingua.entity.RefreshToken;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.config.inject.ConfigProperty;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;

@ApplicationScoped
public class RefreshTokenService {

    @ConfigProperty(name = "lingua.refresh.lifespan-seconds", defaultValue = "2592000")
    long refreshLifespanSeconds;

    private static final SecureRandom RNG = new SecureRandom();

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public String issue(Long userId) {
        String raw = randomToken();
        RefreshToken rt = new RefreshToken();
        rt.userId = userId;
        rt.tokenHash = sha256Hex(raw);
        rt.revoked = false;
        rt.createdAt = LocalDateTime.now();
        rt.expiresAt = LocalDateTime.now().plusSeconds(refreshLifespanSeconds);
        rt.persist();
        return raw;
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public RotatedToken rotate(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) return null;
        RefreshToken existing = RefreshToken.findByHash(sha256Hex(rawToken));
        if (existing == null) return null;
        if (Boolean.TRUE.equals(existing.revoked)) return null;
        if (existing.expiresAt != null && existing.expiresAt.isBefore(LocalDateTime.now())) return null;

        existing.revoked = true;
        existing.persist();

        String newRaw = randomToken();
        RefreshToken next = new RefreshToken();
        next.userId = existing.userId;
        next.tokenHash = sha256Hex(newRaw);
        next.revoked = false;
        next.createdAt = LocalDateTime.now();
        next.expiresAt = LocalDateTime.now().plusSeconds(refreshLifespanSeconds);
        next.persist();

        return new RotatedToken(existing.userId, newRaw, next.expiresAt);
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public void revoke(String rawToken) {
        if (rawToken == null) return;
        RefreshToken existing = RefreshToken.findByHash(sha256Hex(rawToken));
        if (existing != null && !Boolean.TRUE.equals(existing.revoked)) {
            existing.revoked = true;
            existing.persist();
        }
    }

    @Transactional(Transactional.TxType.REQUIRES_NEW)
    public long revokeAll(Long userId) {
        return RefreshToken.update("revoked = true where userId = ?1 and revoked = false", userId);
    }

    private String randomToken() {
        byte[] buf = new byte[32];
        RNG.nextBytes(buf);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(buf);
    }

    private String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] dig = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(dig.length * 2);
            for (byte b : dig) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
    }

    public record RotatedToken(Long userId, String rawToken, LocalDateTime expiresAt) {}
}
