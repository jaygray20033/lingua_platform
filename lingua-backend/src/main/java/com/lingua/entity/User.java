package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User extends PanacheEntityBase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(unique = true, nullable = false)
    public String email;

    @Column(name = "password_hash")
    public String passwordHash;

    @Column(name = "display_name", nullable = false)
    public String displayName;

    @Column(name = "avatar_url")
    public String avatarUrl;

    @Column(name = "auth_provider")
    @Enumerated(EnumType.STRING)
    public AuthProvider authProvider = AuthProvider.LOCAL;

    @Column(name = "native_language_code")
    public String nativeLanguageCode = "vi";

    public String timezone = "Asia/Ho_Chi_Minh";

    @Column(name = "ui_language")
    public String uiLanguage = "vi";

    @Enumerated(EnumType.STRING)
    public Role role = Role.LEARNER;

    @Column(name = "email_verified")
    public Boolean emailVerified = false;

    @Enumerated(EnumType.STRING)
    public Status status = Status.ACTIVE;

    @Column(name = "created_at")
    public LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    public LocalDateTime updatedAt = LocalDateTime.now();

    public enum AuthProvider { LOCAL, GOOGLE, FACEBOOK, APPLE }
    public enum Role { LEARNER, PREMIUM_LEARNER, CONTENT_CREATOR, TEACHER, ADMIN }
    public enum Status { ACTIVE, SUSPENDED, BANNED, DELETED }

    public static User findByEmail(String email) {
        return find("email", email).firstResult();
    }
}
