package com.lingua.service;

import com.lingua.entity.User;
import com.lingua.entity.UserGamification;
import io.smallrye.jwt.build.Jwt;
import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.mindrot.jbcrypt.BCrypt;

import java.time.Duration;
import java.util.Set;

@ApplicationScoped
public class AuthService {

    @ConfigProperty(name = "smallrye.jwt.new-token.issuer", defaultValue = "lingua-platform")
    String issuer;

    @ConfigProperty(name = "lingua.jwt.lifespan-seconds", defaultValue = "3600")
    long jwtLifespanSeconds;

    public User register(String email, String password, String displayName) {
        User user = new User();
        user.email = email == null ? null : email.trim().toLowerCase();
        user.passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
        user.displayName = displayName;
        user.emailVerified = true;
        user.role = User.Role.LEARNER;
        user.persist();

        UserGamification gam = new UserGamification();
        gam.userId = user.id;
        gam.totalXp = 0L;
        gam.gems = 50;
        gam.hearts = 5;
        gam.persist();

        return user;
    }

    public User authenticate(String email, String password) {
        if (email == null || password == null) return null;
        User user = User.findByEmail(email.trim().toLowerCase());
        if (user == null) return null;
        if (!BCrypt.checkpw(password, user.passwordHash)) return null;
        return user;
    }

    public String generateToken(User user) {
        return Jwt.issuer(issuer)
                .subject(user.id.toString())
                .upn(user.email)
                .claim("role", user.role.name())
                .claim("displayName", user.displayName)
                .groups(Set.of(user.role.name()))
                .expiresIn(Duration.ofSeconds(jwtLifespanSeconds))
                .sign();
    }
}
