package com.lingua.resource;

import com.lingua.entity.*;
import com.lingua.service.GamificationService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/gamification")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class GamificationResource {

    @Inject JsonWebToken jwt;
    @Inject GamificationService gamificationService;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @GET
    @Path("/me")
    @Authenticated
    @Transactional
    public Response getGamification() {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401)
                .entity(Map.of("success", false, "message", "Unauthorized"))
                .build();
        }

        User user = User.findById(userId);
        if (user == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "User not found")).build();
        }

        UserGamification gam = gamificationService.ensure(userId);

        gamificationService.regenerateHeartsIfNeeded(gam);

        int dailyGoal = gamificationService.dailyGoal(userId);
        DailyXpLog todayLog = DailyXpLog.find(userId, LocalDate.now());
        int xpToday = (todayLog != null && todayLog.xpGained != null) ? todayLog.xpGained : 0;

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("userId", userId);
        data.put("displayName", user.displayName);
        data.put("email", user.email);
        data.put("avatarUrl", user.avatarUrl != null ? user.avatarUrl : "");
        data.put("totalXp", gam.totalXp);
        data.put("level", gam.level);
        data.put("gems", gam.gems);
        data.put("hearts", gam.hearts);
        data.put("maxHearts", GamificationService.MAX_HEARTS);
        data.put("heartsUpdatedAt", gam.heartsUpdatedAt != null ? gam.heartsUpdatedAt.toString() : null);

        if (gam.hearts != null && gam.hearts < GamificationService.MAX_HEARTS && gam.heartsUpdatedAt != null) {
            data.put("nextHeartAt", gam.heartsUpdatedAt
                .plusMinutes(GamificationService.HEART_REGEN_MINUTES).toString());
            data.put("heartRegenMinutes", GamificationService.HEART_REGEN_MINUTES);
        } else {
            data.put("nextHeartAt", null);
            data.put("heartRegenMinutes", GamificationService.HEART_REGEN_MINUTES);
        }
        data.put("streakCount", gam.streakCount);
        data.put("longestStreak", gam.longestStreak);
        data.put("lastStreakDate", gam.lastStreakDate);
        data.put("streakFreezeCount", gam.streakFreezeCount);
        data.put("dailyXpGoal", dailyGoal);
        data.put("xpToday", xpToday);
        data.put("dailyGoalMet", xpToday >= dailyGoal);

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @PUT
    @Path("/daily-goal")
    @Authenticated
    @Transactional
    public Response setDailyGoal(Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        int xp;
        try {
            Object v = body != null ? body.get("xp") : null;
            if (v instanceof Number) xp = ((Number) v).intValue();
            else xp = Integer.parseInt(String.valueOf(v));
        } catch (Exception e) {
            return Response.status(400).entity(Map.of("success", false, "message", "xp is required")).build();
        }

        try {
            UserDailyGoal g = gamificationService.setDailyGoal(userId, xp);
            return Response.ok(Map.of("success", true, "data", Map.of("dailyXpGoal", g.dailyXpGoal))).build();
        } catch (IllegalArgumentException e) {
            return Response.status(400).entity(Map.of("success", false, "message", e.getMessage())).build();
        }
    }

    @POST
    @Path("/streak-freeze/buy")
    @Authenticated
    @Transactional
    public Response buyStreakFreeze() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        try {
            UserGamification gam = gamificationService.buyStreakFreeze(userId);
            return Response.ok(Map.of(
                "success", true,
                "data", Map.of(
                    "gems", gam.gems,
                    "streakFreezeCount", gam.streakFreezeCount
                ),
                "message", "Đã mua 1 lá chắn streak"
            )).build();
        } catch (IllegalStateException e) {
            return Response.status(400).entity(Map.of("success", false, "message", e.getMessage())).build();
        }
    }

    @POST
    @Path("/hearts/refill")
    @Authenticated
    @Transactional
    public Response refillHearts() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        try {
            UserGamification gam = gamificationService.refillHeartsWithGems(userId);
            return Response.ok(Map.of(
                "success", true,
                "data", Map.of("hearts", gam.hearts, "gems", gam.gems),
                "message", "Hearts refilled"
            )).build();
        } catch (IllegalStateException e) {
            return Response.status(400).entity(Map.of("success", false, "message", e.getMessage())).build();
        }
    }

    @GET
    @Path("/leaderboard")
    @PermitAll
    public Response leaderboard(@QueryParam("period") @DefaultValue("all") String period,
                                @QueryParam("limit") @DefaultValue("10") int limit) {
        limit = Math.max(1, Math.min(limit, 100));

        if ("weekly".equalsIgnoreCase(period)) {
            LocalDate today = LocalDate.now();
            LocalDate monday = today.minusDays(today.getDayOfWeek().getValue() - 1L);

            List<Object[]> rows = DailyXpLog.getEntityManager().createNativeQuery(
                "SELECT u.id, u.display_name, u.avatar_url, COALESCE(SUM(d.xp_gained),0) AS wxp " +
                "FROM users u LEFT JOIN daily_xp_logs d " +
                "  ON d.user_id = u.id AND d.log_date >= ?1 " +
                "WHERE u.status = 'ACTIVE' " +
                "GROUP BY u.id ORDER BY wxp DESC, u.id ASC LIMIT ?2"
            ).setParameter(1, monday).setParameter(2, limit).getResultList();

            List<Map<String, Object>> data = new ArrayList<>();
            int rank = 1;
            for (Object[] r : rows) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("rank", rank++);
                m.put("userId", ((Number) r[0]).longValue());
                m.put("displayName", r[1]);
                m.put("avatarUrl", r[2]);
                m.put("weeklyXp", ((Number) r[3]).longValue());
                data.add(m);
            }
            return Response.ok(Map.of("success", true, "data", data, "period", "weekly", "weekStart", monday.toString())).build();
        }

        List<UserGamification> gams = UserGamification.list("order by totalXp desc", (Object[]) null);
        List<Map<String, Object>> data = new ArrayList<>();
        int rank = 1;
        for (UserGamification g : gams) {
            if (data.size() >= limit) break;
            User u = User.findById(g.userId);
            if (u == null) continue;
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("rank", rank++);
            m.put("userId", g.userId);
            m.put("displayName", u.displayName);
            m.put("avatarUrl", u.avatarUrl);
            m.put("totalXp", g.totalXp);
            m.put("level", g.level);
            data.add(m);
        }
        return Response.ok(Map.of("success", true, "data", data, "period", "all")).build();
    }

    @GET
    @Path("/analytics")
    @Authenticated
    public Response analytics(@QueryParam("days") @DefaultValue("14") int days) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        days = Math.max(1, Math.min(days, 90));

        List<DailyXpLog> logs = DailyXpLog.recent(userId, days);

        Map<LocalDate, DailyXpLog> byDate = new HashMap<>();
        for (DailyXpLog l : logs) byDate.put(l.logDate, l);

        List<Map<String, Object>> series = new ArrayList<>();
        long totalXpPeriod = 0;
        int goalDaysMet = 0;
        for (int i = days - 1; i >= 0; i--) {
            LocalDate d = LocalDate.now().minusDays(i);
            DailyXpLog l = byDate.get(d);
            int xp = (l != null && l.xpGained != null) ? l.xpGained : 0;
            boolean met = l != null && Boolean.TRUE.equals(l.goalMet);
            totalXpPeriod += xp;
            if (met) goalDaysMet++;
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("date", d.toString());
            entry.put("xp", xp);
            entry.put("goalMet", met);
            series.add(entry);
        }

        long lessonsCompleted = LessonAttempt.count("userId = ?1 and status = ?2",
            userId, LessonAttempt.AttemptStatus.COMPLETED);
        long srsReviews = FlashcardReview.count("userId = ?1 and lastReviewedAt is not null", userId);
        long favorites = UserFavorite.count("userId", userId);

        UserGamification gam = UserGamification.findByUser(userId);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("days", days);
        data.put("series", series);
        data.put("totalXpPeriod", totalXpPeriod);
        data.put("goalDaysMet", goalDaysMet);
        data.put("lessonsCompleted", lessonsCompleted);
        data.put("srsReviews", srsReviews);
        data.put("favorites", favorites);
        data.put("streakCount", gam != null ? gam.streakCount : 0);
        data.put("longestStreak", gam != null ? gam.longestStreak : 0);
        data.put("totalXp", gam != null ? gam.totalXp : 0);
        data.put("level", gam != null ? gam.level : 1);

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/achievements")
    @PermitAll
    public Response listAchievements() {
        Long userId = currentUserId();
        Set<Long> unlockedIds = new HashSet<>();
        Map<Long, java.time.LocalDateTime> unlockedAt = new HashMap<>();
        if (userId != null) {
            for (UserAchievement ua : UserAchievement.findByUser(userId)) {
                unlockedIds.add(ua.achievementId);
                unlockedAt.put(ua.achievementId, ua.unlockedAt);
            }
        }

        List<Map<String, Object>> data = new ArrayList<>();
        for (Object obj : Achievement.listAll()) {
            Achievement a = (Achievement) obj;
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", a.id);
            m.put("code", a.code);
            m.put("title", a.title);
            m.put("description", a.description);
            m.put("iconUrl", a.iconUrl);
            m.put("rarity", a.rarity);
            m.put("unlocked", unlockedIds.contains(a.id));
            if (unlockedAt.containsKey(a.id)) {
                m.put("unlockedAt", unlockedAt.get(a.id).toString());
            }
            data.add(m);
        }
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @POST
    @Path("/achievements/evaluate")
    @Authenticated
    @Transactional
    public Response evaluateAchievements() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        com.lingua.service.AchievementService svc =
            jakarta.enterprise.inject.spi.CDI.current().select(com.lingua.service.AchievementService.class).get();
        List<Long> unlocked = svc.evaluateForUser(userId);
        return Response.ok(Map.of("success", true, "data", Map.of("unlocked", unlocked))).build();
    }

    @GET
    @Path("/languages")
    @PermitAll
    public Response listLanguages() {
        List<Language> langs = Language.listAll();
        List<Map<String, Object>> data = new ArrayList<>();
        for (Language l : langs) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", l.id);
            m.put("code", l.code);
            m.put("name", l.name);
            m.put("nativeName", l.nativeName);
            m.put("flagEmoji", l.flagEmoji);
            data.add(m);
        }
        return Response.ok(Map.of("success", true, "data", data)).build();
    }
}
