package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "daily_xp_logs")
@IdClass(DailyXpLog.PK.class)
public class DailyXpLog extends PanacheEntityBase {

    @Id
    @Column(name = "user_id")
    public Long userId;

    @Id
    @Column(name = "log_date")
    public LocalDate logDate;

    @Column(name = "xp_gained")
    public Integer xpGained = 0;

    @Column(name = "goal_met")
    public Boolean goalMet = false;

    public static DailyXpLog find(Long userId, LocalDate date) {
        return find("userId = ?1 and logDate = ?2", userId, date).firstResult();
    }

    public static List<DailyXpLog> recent(Long userId, int days) {
        LocalDate from = LocalDate.now().minusDays(days - 1);
        return list("userId = ?1 and logDate >= ?2 order by logDate desc", userId, from);
    }

    public static class PK implements Serializable {
        public Long userId;
        public LocalDate logDate;

        public PK() {}
        public PK(Long userId, LocalDate logDate) { this.userId = userId; this.logDate = logDate; }

        @Override public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof PK)) return false;
            PK pk = (PK) o;
            return Objects.equals(userId, pk.userId) && Objects.equals(logDate, pk.logDate);
        }
        @Override public int hashCode() { return Objects.hash(userId, logDate); }
    }
}
