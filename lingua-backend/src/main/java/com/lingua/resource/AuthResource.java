package com.lingua.resource;

import com.lingua.entity.*;
import com.lingua.service.AuthService;
import com.lingua.service.RateLimitService;
import com.lingua.service.RefreshTokenService;
import io.quarkus.security.Authenticated;
import io.vertx.core.http.HttpServerRequest;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.HttpHeaders;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.time.Duration;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

@Path("/api/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {

    @Inject AuthService authService;
    @Inject RefreshTokenService refreshTokenService;
    @Inject RateLimitService rateLimiter;
    @Inject JsonWebToken jwt;

    @Context
    HttpServerRequest vertxRequest;

    @ConfigProperty(name = "lingua.ratelimit.proxy.trusted", defaultValue = "127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16")
    String trustedProxies;

    private static final int LOGIN_MAX_PER_MIN    = 5;
    private static final int REGISTER_MAX_PER_HOUR = 10;
    private static final int REFRESH_MAX_PER_MIN  = 30;
    private static final Duration ONE_MINUTE = Duration.ofMinutes(1);
    private static final Duration ONE_HOUR   = Duration.ofHours(1);

    @POST
    @Path("/register")
    @PermitAll
    @Transactional
    public Response register(Map<String, String> body, @Context HttpHeaders headers) {
        String ip = clientIp(headers);
        if (!rateLimiter.tryAcquire("register:" + ip, REGISTER_MAX_PER_HOUR, ONE_HOUR)) {
            return tooMany("Too many registrations; please retry later");
        }

        String email = body != null ? body.get("email") : null;
        String password = body != null ? body.get("password") : null;
        String displayName = body != null ? body.get("displayName") : null;

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            return Response.status(400).entity(Map.of("success", false, "message", "Email and password are required")).build();
        }

        email = email.trim().toLowerCase();

        if (displayName == null || displayName.isBlank()) {
            int at = email.indexOf('@');
            displayName = at > 0 ? email.substring(0, at) : email;
        } else {
            displayName = displayName.trim();
        }

        if (User.findByEmail(email) != null) {
            return Response.status(409).entity(Map.of("success", false, "message", "EMAIL_EXISTED")).build();
        }

        User user = authService.register(email, password, displayName);
        String token = authService.generateToken(user);

        String refresh = null;
        try {
            refresh = refreshTokenService.issue(user.id);
        } catch (Exception ex) {
            org.jboss.logging.Logger.getLogger(AuthResource.class)
                .warn("Could not issue refresh token at register; cause=" + ex.getMessage());
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("token", token);
        if (refresh != null) data.put("refreshToken", refresh);
        data.put("user", mapUser(user));

        return Response.ok(Map.of(
            "success", true,
            "data", data,
            "message", "Registration successful"
        )).build();
    }

    @POST
    @Path("/login")
    @PermitAll
    @Transactional
    public Response login(Map<String, String> body, @Context HttpHeaders headers) {
        String ip = clientIp(headers);
        String email = body != null ? body.get("email") : null;
        if (email != null) email = email.trim().toLowerCase();

        if (!rateLimiter.tryAcquire("login:ip:" + ip, LOGIN_MAX_PER_MIN, ONE_MINUTE)) {
            return tooMany("Too many login attempts; please retry in a minute");
        }
        if (email != null && !rateLimiter.tryAcquire("login:email:" + email, LOGIN_MAX_PER_MIN, ONE_MINUTE)) {
            return tooMany("Too many login attempts; please retry in a minute");
        }

        String password = body != null ? body.get("password") : null;
        User user = authService.authenticate(email, password);
        if (user == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Invalid credentials")).build();
        }

        if (user.status != null && user.status != User.Status.ACTIVE) {
            String reason;
            switch (user.status) {
                case BANNED:    reason = "Account has been banned"; break;
                case SUSPENDED: reason = "Account is suspended"; break;
                case DELETED:   reason = "Account no longer exists"; break;
                default:        reason = "Account is not active";
            }
            return Response.status(403).entity(Map.of("success", false, "message", reason)).build();
        }

        String token = authService.generateToken(user);
        String refresh = null;
        try {
            refresh = refreshTokenService.issue(user.id);
        } catch (Exception ex) {
            org.jboss.logging.Logger.getLogger(AuthResource.class)
                .warn("Could not issue refresh token at login; cause=" + ex.getMessage());
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("token", token);
        if (refresh != null) data.put("refreshToken", refresh);
        data.put("user", mapUser(user));

        return Response.ok(Map.of(
            "success", true,
            "data", data,
            "message", "Login successful"
        )).build();
    }

    @POST
    @Path("/refresh")
    @PermitAll
    @Transactional
    public Response refresh(Map<String, String> body, @Context HttpHeaders headers) {
        String ip = clientIp(headers);
        if (!rateLimiter.tryAcquire("refresh:" + ip, REFRESH_MAX_PER_MIN, ONE_MINUTE)) {
            return tooMany("Too many refresh attempts");
        }

        String raw = body != null ? body.get("refreshToken") : null;
        if (raw == null || raw.isBlank()) {
            return Response.status(400).entity(Map.of("success", false, "message", "refreshToken required")).build();
        }
        RefreshTokenService.RotatedToken rotated = refreshTokenService.rotate(raw);
        if (rotated == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Invalid or expired refresh token")).build();
        }
        User user = User.findById(rotated.userId());
        if (user == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "User not found")).build();
        }
        if (user.status != null && user.status != User.Status.ACTIVE) {
            return Response.status(403).entity(Map.of("success", false, "message", "Account is not active")).build();
        }
        String newAccess = authService.generateToken(user);
        return Response.ok(Map.of(
            "success", true,
            "data", Map.of(
                "token", newAccess,
                "refreshToken", rotated.rawToken(),
                "expiresAt", rotated.expiresAt().toString()
            )
        )).build();
    }

    @GET
    @Path("/me")
    @Authenticated
    public Response me() {
        Long uid = currentUserId();
        if (uid == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        User u = User.findById(uid);
        if (u == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "User not found")).build();
        }
        return Response.ok(Map.of("success", true, "data", mapUser(u))).build();
    }

    @PUT
    @Path("/me")
    @Authenticated
    @Transactional
    public Response updateMe(Map<String, String> body) {
        Long uid = currentUserId();
        if (uid == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        User u = User.findById(uid);
        if (u == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "User not found")).build();
        }

        if (body != null) {
            if (body.containsKey("displayName")) {
                String dn = body.get("displayName");
                if (dn != null && !dn.isBlank()) u.displayName = dn.trim();
            }
            if (body.containsKey("uiLanguage")) {
                String ui = body.get("uiLanguage");
                if (ui != null && !ui.isBlank()) u.uiLanguage = ui.trim();
            }
            if (body.containsKey("nativeLanguageCode")) {
                String nl = body.get("nativeLanguageCode");
                if (nl != null && !nl.isBlank()) u.nativeLanguageCode = nl.trim();
            }
            if (body.containsKey("timezone")) {
                String tz = body.get("timezone");
                if (tz != null && !tz.isBlank()) u.timezone = tz.trim();
            }
            if (body.containsKey("avatarUrl")) {
                u.avatarUrl = body.get("avatarUrl");
            }
            u.updatedAt = java.time.LocalDateTime.now();
            u.persist();
        }

        return Response.ok(Map.of("success", true, "data", mapUser(u), "message", "Profile updated")).build();
    }

    @POST
    @Path("/logout")
    @PermitAll
    @Transactional
    public Response logout(Map<String, String> body) {
        if (body != null) {
            String raw = body.get("refreshToken");
            if (raw != null && !raw.isBlank()) {
                refreshTokenService.revoke(raw);
            }
        }
        return Response.ok(Map.of("success", true, "message", "Logged out")).build();
    }

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    private static Response tooMany(String msg) {
        return Response.status(429).entity(Map.of("success", false, "message", msg)).build();
    }

    private String clientIp(HttpHeaders headers) {
        if (isFromTrustedProxy()) {
            String fwd = headers != null ? headers.getHeaderString("X-Forwarded-For") : null;
            String real = headers != null ? headers.getHeaderString("X-Real-IP") : null;
            if (fwd != null && !fwd.isBlank()) return fwd.split(",")[0].trim();
            if (real != null && !real.isBlank()) return real.trim();
        }
        try {
            if (vertxRequest != null && vertxRequest.remoteAddress() != null) {
                return vertxRequest.remoteAddress().host();
            }
        } catch (Exception ignored) {}
        return "unknown";
    }

    private boolean isFromTrustedProxy() {
        if (trustedProxies == null || trustedProxies.isBlank()) return false;
        try {
            if (vertxRequest == null || vertxRequest.remoteAddress() == null) return false;
            String remoteIp = vertxRequest.remoteAddress().host();
            if (remoteIp == null) return false;
            return Arrays.stream(trustedProxies.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .anyMatch(t -> t.equals(remoteIp));
        } catch (Exception e) {
            return false;
        }
    }

    private Map<String, Object> mapUser(User u) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", u.id);
        m.put("email", u.email);
        m.put("displayName", u.displayName);
        m.put("role", u.role != null ? u.role.name() : "LEARNER");
        m.put("avatarUrl", u.avatarUrl != null ? u.avatarUrl : "");
        m.put("nativeLanguageCode", u.nativeLanguageCode != null ? u.nativeLanguageCode : "vi");
        m.put("uiLanguage", u.uiLanguage != null ? u.uiLanguage : "vi");
        m.put("timezone", u.timezone != null ? u.timezone : "Asia/Ho_Chi_Minh");
        m.put("emailVerified", u.emailVerified != null ? u.emailVerified : false);
        m.put("status", u.status != null ? u.status.name() : "ACTIVE");
        m.put("createdAt", u.createdAt != null ? u.createdAt.toString() : null);
        m.put("updatedAt", u.updatedAt != null ? u.updatedAt.toString() : null);
        return m;
    }
}