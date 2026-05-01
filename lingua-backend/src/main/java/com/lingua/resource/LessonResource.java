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

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class LessonResource {

    @Inject JsonWebToken jwt;
    @Inject GamificationService gamificationService;

    @Inject com.lingua.service.QuestService questService;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @GET
    @Path("/lessons/{id}")
    @PermitAll
    public Response getLesson(@PathParam("id") Long id) {
        Lesson lesson = Lesson.findById(id);
        if (lesson == null) return Response.status(404).build();

        List<Exercise> exercises = Exercise.findByLesson(id);
        List<Map<String, Object>> exerciseList = exercises.stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", e.id);
            m.put("type", e.type);
            m.put("promptJson", e.promptJson);
            m.put("answerJson", e.answerJson);
            m.put("hintJson", e.hintJson);
            m.put("audioUrl", e.audioUrl);
            m.put("imageUrl", e.imageUrl);
            m.put("difficulty", e.difficulty);
            m.put("orderIndex", e.orderIndex);
            return m;
        }).collect(Collectors.toList());

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", lesson.id);
        data.put("title", lesson.title);
        data.put("type", lesson.type.name());
        data.put("xpReward", lesson.xpReward);
        data.put("exerciseCount", lesson.exerciseCount);
        data.put("exercises", exerciseList);

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/exercises/by-lesson/{lessonId}")
    @PermitAll
    public Response getExercisesByLesson(@PathParam("lessonId") Long lessonId) {
        List<Exercise> exercises = Exercise.findByLesson(lessonId);
        List<Map<String, Object>> data = exercises.stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", e.id);
            m.put("type", e.type);
            m.put("promptJson", e.promptJson);
            m.put("answerJson", e.answerJson);
            m.put("hintJson", e.hintJson);
            m.put("difficulty", e.difficulty);
            return m;
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @POST
    @Path("/lessons/{id}/complete")
    @Authenticated
    @Transactional
    public Response completeLesson(@PathParam("id") Long lessonId, Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        Lesson lesson = Lesson.findById(lessonId);
        if (lesson == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "Lesson not found")).build();
        }

        Map<String, Object> b = body != null ? body : Map.of();
        double score = toDouble(b.get("score"), 0.0);
        int xpEarned = toInt(b.get("xpEarned"), lesson.xpReward != null ? lesson.xpReward : 10);
        int heartsLost = toInt(b.get("heartsLost"), 0);
        int durationSec = toInt(b.get("durationSec"), 0);

        String idemKey = b.get("idempotencyKey") != null ? String.valueOf(b.get("idempotencyKey")) : null;
        if (idemKey != null && !idemKey.isBlank()) {
            LessonAttempt prior = LessonAttempt
                .find("userId = ?1 and lessonId = ?2 and idempotencyKey = ?3", userId, lessonId, idemKey)
                .firstResult();
            if (prior != null) {
                Map<String, Object> dupData = new LinkedHashMap<>();
                dupData.put("attemptId", prior.id);
                dupData.put("lessonId", lessonId);
                dupData.put("score", prior.scorePercent);
                dupData.put("xpEarned", prior.xpEarned);
                dupData.put("duplicate", true);
                return Response.ok(Map.of(
                    "success", true, "data", dupData,
                    "message", "Duplicate submission ignored (idempotency key match)"
                )).build();
            }
        }

        LessonAttempt recent = LessonAttempt
            .find("userId = ?1 and lessonId = ?2 and status = ?3 and completedAt >= ?4 order by completedAt desc",
                userId, lessonId, LessonAttempt.AttemptStatus.COMPLETED,
                LocalDateTime.now().minusSeconds(5))
            .firstResult();
        if (recent != null) {
            UserLessonProgress existing = UserLessonProgress.findByUserAndLesson(userId, lessonId);
            Map<String, Object> dupData = new LinkedHashMap<>();
            dupData.put("attemptId", recent.id);
            dupData.put("lessonId", lessonId);
            dupData.put("score", recent.scorePercent);
            dupData.put("xpEarned", recent.xpEarned);
            dupData.put("duplicate", true);
            if (existing != null) {
                dupData.put("completionCount", existing.completionCount);
                dupData.put("bestScore", existing.bestScore);
            }
            return Response.ok(Map.of(
                "success", true, "data", dupData,
                "message", "Duplicate submission ignored (idempotent replay)"
            )).build();
        }

        if (score >= 99.5) xpEarned += 5;

        LessonAttempt attempt = new LessonAttempt();
        attempt.userId = userId;
        attempt.lessonId = lessonId;
        attempt.status = LessonAttempt.AttemptStatus.COMPLETED;
        attempt.idempotencyKey = idemKey;
        attempt.scorePercent = score;
        attempt.xpEarned = xpEarned;
        attempt.heartsLost = heartsLost;
        attempt.durationSec = durationSec;
        attempt.startedAt = LocalDateTime.now().minusSeconds(durationSec);
        attempt.completedAt = LocalDateTime.now();
        attempt.persist();

        UserLessonProgress progress = UserLessonProgress.findByUserAndLesson(userId, lessonId);
        if (progress == null) {
            progress = new UserLessonProgress();
            progress.userId = userId;
            progress.lessonId = lessonId;
            progress.completionCount = 0;
            progress.bestScore = 0.0;
            progress.isLegendary = false;
        }
        progress.completionCount = (progress.completionCount == null ? 0 : progress.completionCount) + 1;
        if (score > (progress.bestScore == null ? 0.0 : progress.bestScore)) {
            progress.bestScore = score;
        }
        progress.lastCompletedAt = LocalDateTime.now();
        progress.persist();

        UserGamification gam = gamificationService.awardXp(userId, xpEarned);

        try { questService.bumpCategory(userId, "LESSON", 1); } catch (Exception ignore) {}

        boolean queuedForReview = false;
        try {
            LessonReviewQueue rq = LessonReviewQueue.findByUserAndLesson(userId, lessonId);
            if (score < 70.0) {
                if (rq == null) {
                    rq = new LessonReviewQueue();
                    rq.userId = userId;
                    rq.lessonId = lessonId;
                    rq.failCount = 1;
                } else {
                    rq.failCount = (rq.failCount == null ? 0 : rq.failCount) + 1;
                    rq.resolved = false;
                    rq.resolvedAt = null;
                }
                rq.lastScore = score;
                rq.lastFailedAt = LocalDateTime.now();

                int delayDays = Math.min(3, Math.max(1, rq.failCount));
                rq.reviewAfter = java.time.LocalDate.now().plusDays(delayDays);
                rq.persist();
                queuedForReview = true;
            } else if (rq != null && !Boolean.TRUE.equals(rq.resolved)) {
                rq.resolved = true;
                rq.resolvedAt = LocalDateTime.now();
                rq.lastScore = score;
                rq.persist();
            }
        } catch (Exception ignore) {  }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("attemptId", attempt.id);
        data.put("lessonId", lessonId);
        data.put("score", score);
        data.put("xpEarned", xpEarned);
        data.put("totalXp", gam.totalXp);
        data.put("level", gam.level);
        data.put("streakCount", gam.streakCount);
        data.put("completionCount", progress.completionCount);
        data.put("bestScore", progress.bestScore);
        data.put("queuedForReview", queuedForReview);
        return Response.ok(Map.of("success", true, "data", data, "message", "Lesson completed")).build();
    }

    @GET
    @Path("/lessons/review-queue")
    @Authenticated
    public Response getReviewQueue() {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }

        List<LessonReviewQueue> pending = LessonReviewQueue.pendingForUser(userId);
        List<Map<String, Object>> data = new ArrayList<>();
        for (LessonReviewQueue rq : pending) {
            Lesson l = Lesson.findById(rq.lessonId);
            if (l == null) continue;
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", rq.id);
            m.put("lessonId", rq.lessonId);
            m.put("lessonTitle", l.title);
            m.put("lastScore", rq.lastScore);
            m.put("failCount", rq.failCount);
            m.put("reviewAfter", rq.reviewAfter != null ? rq.reviewAfter.toString() : null);
            m.put("lastFailedAt", rq.lastFailedAt != null ? rq.lastFailedAt.toString() : null);
            m.put("xpReward", l.xpReward);
            data.add(m);
        }
        return Response.ok(Map.of(
            "success", true,
            "data", data,
            "totalCount", data.size()
        )).build();
    }

    private static double toDouble(Object v, double fallback) {
        if (v == null) return fallback;
        if (v instanceof Number) return ((Number) v).doubleValue();
        try { return Double.parseDouble(v.toString()); } catch (Exception e) { return fallback; }
    }

    private static int toInt(Object v, int fallback) {
        if (v == null) return fallback;
        if (v instanceof Number) return ((Number) v).intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return fallback; }
    }
}
