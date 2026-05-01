package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "user_favorites")
public class UserFavorite extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "user_id")
    public Long userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "item_type")
    public ItemType itemType;

    @Column(name = "item_id")
    public Long itemId;

    @Column(name = "created_at")
    public LocalDateTime createdAt = LocalDateTime.now();

    public enum ItemType { WORD, CHARACTER, GRAMMAR }

    public static UserFavorite find(Long userId, ItemType type, Long itemId) {
        return find("userId = ?1 and itemType = ?2 and itemId = ?3", userId, type, itemId).firstResult();
    }

    public static List<UserFavorite> findByUserAndType(Long userId, ItemType type) {
        return list("userId = ?1 and itemType = ?2 order by createdAt desc", userId, type);
    }

    public static List<UserFavorite> findByUser(Long userId) {
        return list("userId = ?1 order by createdAt desc", userId);
    }
}
