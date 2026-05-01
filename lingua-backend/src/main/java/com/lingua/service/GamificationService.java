package com.lingua.service;

import com.lingua.entity.DailyXpLog;
import com.lingua.entity.UserDailyGoal;
import com.lingua.entity.UserGamification;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@ApplicationScoped
public class GamificationService {

    public static final int HEART_REGEN_MINUTES = 30;
    public static final int MAX_HEARTS = 5;
    public static final int REFILL_COST_GEMS = 30;

    @Inject AchievementService achievementService;

    @Inject QuestService questService;

    @Transactional
    public UserGamification ensure(Long userId) {
        UserGamification gam = UserGamification.findByUser(userId);
        if (gam == null) {
            gam = new UserGamification();
            gam.userId = userId;
            gam.totalXp = 0L;
            gam.gems = 50;
            gam.hearts = MAX_HEARTS;
            gam.heartsUpdatedAt = LocalDateTime.now();
            gam.persist();
        }
        return gam;
    }

    @Transactional
    public UserGamification regenerateHeartsIfNeeded(UserGamification gam) {
        if (gam == null) return null;
        int current = gam.hearts == null ? 0 : gam.hearts;
        if (current >= MAX_HEARTS) {

            if (gam.heartsUpdatedAt == null) {
                gam.heartsUpdatedAt = LocalDateTime.now();
                gam.persist();
            }
            return gam;
        }
        LocalDateTime base = gam.heartsUpdatedAt != null ? gam.heartsUpdatedAt : LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(base, LocalDateTime.now());
        if (minutes < HEART_REGEN_MINUTES) return gam;

        int gained = (int) Math.min(MAX_HEARTS - current, minutes / HEART_REGEN_MINUTES);
        if (gained <= 0) return gam;

        gam.hearts = current + gained;

        gam.heartsUpdatedAt = base.plusMinutes((long) gained * HEART_REGEN_MINUTES);
        if (gam.hearts >= MAX_HEARTS) {
            gam.hearts = MAX_HEARTS;
            gam.heartsUpdatedAt = LocalDateTime.now();
        }
        gam.persist();
        return gam;
    }

    @Transactional
    public UserGamification awardXp(Long userId, int xp) {
        if (xp <= 0) return ensure(userId);
        UserGamification gam = ensure(userId);
        long newXp = (gam.totalXp == null ? 0L : gam.totalXp) + xp;
        gam.totalXp = newXp;
        gam.level = 1 + (int) (newXp / 100);

        LocalDate today = LocalDate.now();
        DailyXpLog log = DailyXpLog.find(userId, today);
        if (log == null) {
            log = new DailyXpLog();
            log.userId = userId;
            log.logDate = today;
            log.xpGained = 0;
            log.goalMet = false;
        }
        log.xpGained = (log.xpGained == null ? 0 : log.xpGained) + xp;
        int goal = dailyGoal(userId);
        log.goalMet = log.xpGained >= goal;
        log.persist();

        updateStreakIfEligible(gam, log);
        gam.persist();

        achievementService.evaluateForUser(userId);

        try {
            questService.syncXpToday(userId, log.xpGained == null ? 0 : log.xpGained);
        } catch (Exception ignore) {  }
        return gam;
    }

    @Transactional
    public UserGamification loseHeart(Long userId) {
        UserGamification gam = ensure(userId);
        regenerateHeartsIfNeeded(gam);
        if (gam.hearts != null && gam.hearts > 0) {
            gam.hearts -= 1;
            gam.heartsUpdatedAt = LocalDateTime.now();
            gam.persist();
        }
        return gam;
    }

    @Transactional
    public UserGamification refillHeartsWithGems(Long userId) {
        UserGamification gam = ensure(userId);
        regenerateHeartsIfNeeded(gam);
        if (gam.hearts != null && gam.hearts >= MAX_HEARTS) return gam;
        if (gam.gems == null || gam.gems < REFILL_COST_GEMS) {
            throw new IllegalStateException("NOT_ENOUGH_GEMS");
        }
        gam.gems -= REFILL_COST_GEMS;
        gam.hearts = MAX_HEARTS;
        gam.heartsUpdatedAt = LocalDateTime.now();
        gam.persist();
        return gam;
    }

    private void updateStreakIfEligible(UserGamification gam, DailyXpLog todayLog) {
        LocalDate today = LocalDate.now();
        LocalDate last = gam.lastStreakDate;
        if (last != null && last.equals(today)) return;

        if (last == null || last.isBefore(today.minusDays(1))) {

            if (gam.streakFreezeCount != null && gam.streakFreezeCount > 0 && last != null && last.isBefore(today.minusDays(1))) {
                gam.streakFreezeCount -= 1;

            } else {
                gam.streakCount = 1;
            }
        } else {

            gam.streakCount = (gam.streakCount == null ? 0 : gam.streakCount) + 1;
        }
        gam.lastStreakDate = today;
        if (gam.longestStreak == null || gam.streakCount > gam.longestStreak) {
            gam.longestStreak = gam.streakCount;
        }
    }

    public int dailyGoal(Long userId) {
        UserDailyGoal g = UserDailyGoal.findByUser(userId);
        return (g != null && g.dailyXpGoal != null) ? g.dailyXpGoal : 20;
    }

    public static final int FREEZE_COST_GEMS = 100;
    public static final int MAX_FREEZE_STOCK = 2;

    @Transactional
    public UserGamification buyStreakFreeze(Long userId) {
        UserGamification gam = ensure(userId);
        int cur = gam.streakFreezeCount == null ? 0 : gam.streakFreezeCount;
        if (cur >= MAX_FREEZE_STOCK) throw new IllegalStateException("MAX_FREEZE_REACHED");
        if (gam.gems == null || gam.gems < FREEZE_COST_GEMS) throw new IllegalStateException("NOT_ENOUGH_GEMS");
        gam.gems -= FREEZE_COST_GEMS;
        gam.streakFreezeCount = cur + 1;
        gam.persist();
        return gam;
    }

    @Transactional
    public UserDailyGoal setDailyGoal(Long userId, int xp) {
        if (xp < 5 || xp > 200) throw new IllegalArgumentException("Daily goal must be between 5 and 200 XP");
        UserDailyGoal g = UserDailyGoal.findByUser(userId);
        if (g == null) {
            g = new UserDailyGoal();
            g.userId = userId;
        }
        g.dailyXpGoal = xp;
        g.updatedAt = LocalDateTime.now();
        g.persist();
        return g;
    }
}
