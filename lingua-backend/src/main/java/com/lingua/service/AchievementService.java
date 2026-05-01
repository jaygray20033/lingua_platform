package com.lingua.service;

import com.lingua.entity.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;
import org.jboss.logging.Logger;

import java.util.ArrayList;
import java.util.List;

@ApplicationScoped
public class AchievementService {
    private static final Logger LOG = Logger.getLogger(AchievementService.class);
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Transactional
    public List<Long> evaluateForUser(Long userId) {
        List<Long> unlocked = new ArrayList<>();
        UserGamification gam = UserGamification.findByUser(userId);
        if (gam == null) return unlocked;

        long totalXp = gam.totalXp == null ? 0L : gam.totalXp;
        int streak = gam.streakCount == null ? 0 : gam.streakCount;
        long lessons = LessonAttempt.count("userId = ?1 and status = ?2", userId, LessonAttempt.AttemptStatus.COMPLETED);
        long srsReviews = FlashcardReview.count("userId = ?1 and lastReviewedAt is not null", userId);

        List<Achievement> all = Achievement.listAll();
        for (Achievement a : all) {
            if (a.triggerRule == null || a.triggerRule.isBlank()) continue;

            if (UserAchievement.find(userId, a.id) != null) continue;

            boolean ok = false;
            try {
                JsonNode rule = MAPPER.readTree(a.triggerRule);
                String type = rule.path("type").asText("");
                long threshold = rule.path("threshold").asLong(0);
                switch (type) {
                    case "TOTAL_XP":          ok = totalXp   >= threshold; break;
                    case "STREAK_DAYS":       ok = streak    >= threshold; break;
                    case "LESSONS_COMPLETED": ok = lessons   >= threshold; break;
                    case "SRS_REVIEWS":       ok = srsReviews >= threshold; break;
                    default:
                        LOG.debugf("Unknown achievement trigger type '%s' for code=%s", type, a.code);
                }
            } catch (Exception e) {
                LOG.warnf("Invalid trigger_rule JSON for achievement id=%d code=%s: %s", a.id, a.code, e.getMessage());
                continue;
            }

            if (ok) {
                UserAchievement ua = new UserAchievement();
                ua.userId = userId;
                ua.achievementId = a.id;
                ua.progress = 100;
                ua.unlockedAt = java.time.LocalDateTime.now();
                ua.persist();
                unlocked.add(a.id);
                LOG.infof("Unlocked achievement '%s' for user %d", a.code, userId);
            }
        }
        return unlocked;
    }
}
