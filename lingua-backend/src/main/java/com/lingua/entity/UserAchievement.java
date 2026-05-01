package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "user_achievements")
@IdClass(UserAchievement.PK.class)
public class UserAchievement extends PanacheEntityBase {

    @Id
    @Column(name = "user_id")
    public Long userId;

    @Id
    @Column(name = "achievement_id")
    public Long achievementId;

    @Column(name = "unlocked_at")
    public LocalDateTime unlockedAt = LocalDateTime.now();

    public Integer progress = 0;

    public static UserAchievement find(Long userId, Long achievementId) {
        return find("userId = ?1 and achievementId = ?2", userId, achievementId).firstResult();
    }

    public static List<UserAchievement> findByUser(Long userId) {
        return list("userId = ?1 order by unlockedAt desc", userId);
    }

    public static class PK implements Serializable {
        public Long userId;
        public Long achievementId;

        public PK() {}
        public PK(Long userId, Long achievementId) { this.userId = userId; this.achievementId = achievementId; }

        @Override public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof PK)) return false;
            PK pk = (PK) o;
            return Objects.equals(userId, pk.userId) && Objects.equals(achievementId, pk.achievementId);
        }
        @Override public int hashCode() { return Objects.hash(userId, achievementId); }
    }
}
