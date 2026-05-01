package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "refresh_tokens")
public class RefreshToken extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "user_id")
    public Long userId;

    @Column(name = "token_hash", length = 128)
    public String tokenHash;

    @Column(name = "expires_at")
    public LocalDateTime expiresAt;

    @Column(name = "revoked")
    public Boolean revoked = false;

    @Column(name = "created_at")
    public LocalDateTime createdAt = LocalDateTime.now();

    public static RefreshToken findByHash(String hash) {
        return find("tokenHash", hash).firstResult();
    }
}
