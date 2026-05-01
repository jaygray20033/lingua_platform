package com.lingua.resource;

import com.fasterxml.jackson.core.type.TypeReference;
import com.lingua.entity.*;
import com.lingua.service.CacheService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/courses")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@PermitAll
public class CourseResource {

    @Inject CacheService cache;
    @Inject JsonWebToken jwt;

    @GET
    public Response listCourses(
        @QueryParam("language") String language,
        @QueryParam("level") String level,
        @QueryParam("certification") String cert) {

        String key = "courses:public:" + String.valueOf(language) + ":" + String.valueOf(level) + ":" + String.valueOf(cert);
        List<Map<String, Object>> data = cache.getOrCompute(
            key,
            Duration.ofMinutes(15),
            new TypeReference<List<Map<String, Object>>>() {},
            () -> {
                List<Course> courses;
                if (cert != null && !cert.isEmpty()) {
                    courses = Course.list("certification = ?1 and status = 'PUBLISHED'", Course.Certification.valueOf(cert));
                } else if (language != null) {
                    Language lang = Language.findByCode(language);
                    if (lang != null) courses = Course.findByLanguage(lang.id);
                    else courses = Course.findPublished();
                } else {
                    courses = Course.findPublished();
                }
                return courses.stream().map(this::mapCourse).collect(Collectors.toList());
            }
        );
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}")
    public Response getCourse(@PathParam("id") Long id) {
        String key = "course:public:" + id;
        Map<String, Object> data = cache.getOrCompute(
            key,
            Duration.ofMinutes(30),
            new TypeReference<Map<String, Object>>() {},
            () -> {
                Course course = Course.findById(id);
                if (course == null) return null;
                Map<String, Object> d = mapCourse(course);
                Language targetLang = Language.findById(course.targetLangId);
                Language sourceLang = Language.findById(course.sourceLangId);
                d.put("targetLanguage", targetLang != null ? Map.of("code", targetLang.code, "name", targetLang.name, "flagEmoji", targetLang.flagEmoji) : null);
                d.put("sourceLanguage", sourceLang != null ? Map.of("code", sourceLang.code, "name", sourceLang.name) : null);
                return d;
            }
        );
        if (data == null) return Response.status(404).entity(Map.of("success", false, "message", "Course not found")).build();
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}/path")
    public Response getCoursePath(@PathParam("id") Long id) {
        Course course = Course.findById(id);
        if (course == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "Course not found")).build();
        }

        List<Section> sections = Section.findByCourse(id);
        List<Long> sectionIds = sections.stream().map(s -> s.id).collect(Collectors.toList());

        Map<Long, List<Unit>> unitsBySection = new HashMap<>();
        List<Long> unitIds = new ArrayList<>();
        if (!sectionIds.isEmpty()) {
            List<Unit> allUnits = Unit.list("sectionId in ?1 order by sectionId, orderIndex", sectionIds);
            for (Unit u : allUnits) {
                unitsBySection.computeIfAbsent(u.sectionId, k -> new ArrayList<>()).add(u);
                unitIds.add(u.id);
            }
        }

        Map<Long, List<Lesson>> lessonsByUnit = new HashMap<>();
        List<Long> lessonIds = new ArrayList<>();
        if (!unitIds.isEmpty()) {
            List<Lesson> allLessons = Lesson.list("unitId in ?1 order by unitId, orderIndex", unitIds);
            for (Lesson l : allLessons) {
                lessonsByUnit.computeIfAbsent(l.unitId, k -> new ArrayList<>()).add(l);
                lessonIds.add(l.id);
            }
        }

        Long userId = currentUserId();
        Map<Long, UserLessonProgress> progressByLesson = new HashMap<>();
        if (userId != null && !lessonIds.isEmpty()) {
            List<UserLessonProgress> progressList =
                UserLessonProgress.list("userId = ?1 and lessonId in ?2", userId, lessonIds);
            for (UserLessonProgress p : progressList) {
                progressByLesson.put(p.lessonId, p);
            }
        }

        List<Map<String, Object>> pathData = new ArrayList<>();

        int totalLessonsAll = 0;
        int completedLessonsAll = 0;

        for (Section section : sections) {
            Map<String, Object> sectionMap = new LinkedHashMap<>();
            sectionMap.put("id", section.id);
            sectionMap.put("title", section.title);
            sectionMap.put("description", section.description);
            sectionMap.put("orderIndex", section.orderIndex);

            List<Unit> units = unitsBySection.getOrDefault(section.id, Collections.emptyList());
            List<Map<String, Object>> unitsList = new ArrayList<>();

            int sectionTotal = 0, sectionDone = 0;

            for (Unit unit : units) {
                Map<String, Object> unitMap = new LinkedHashMap<>();
                unitMap.put("id", unit.id);
                unitMap.put("title", unit.title);
                unitMap.put("icon", unit.icon);
                unitMap.put("communicationGoal", unit.communicationGoal);
                unitMap.put("xpReward", unit.xpReward);

                List<Lesson> lessons = lessonsByUnit.getOrDefault(unit.id, Collections.emptyList());
                int unitTotal = lessons.size();
                int unitDone = 0;

                List<Map<String, Object>> lessonsList = new ArrayList<>();
                for (Lesson l : lessons) {
                    Map<String, Object> lm = new LinkedHashMap<>();
                    lm.put("id", l.id);
                    lm.put("title", l.title);
                    lm.put("type", l.type.name());
                    lm.put("xpReward", l.xpReward);
                    lm.put("exerciseCount", l.exerciseCount);
                    UserLessonProgress p = progressByLesson.get(l.id);
                    boolean done = p != null && p.completionCount != null && p.completionCount > 0;
                    lm.put("completed", done);
                    lm.put("bestScore", p != null ? p.bestScore : null);
                    lm.put("completionCount", p != null ? p.completionCount : 0);
                    if (done) unitDone++;
                    lessonsList.add(lm);
                }

                unitMap.put("lessons", lessonsList);
                unitMap.put("totalLessons", unitTotal);
                unitMap.put("completedLessons", unitDone);
                unitMap.put("progressPercent", unitTotal == 0 ? 0 : Math.round(unitDone * 100.0 / unitTotal));
                unitsList.add(unitMap);

                sectionTotal += unitTotal;
                sectionDone += unitDone;
            }
            sectionMap.put("units", unitsList);
            sectionMap.put("totalLessons", sectionTotal);
            sectionMap.put("completedLessons", sectionDone);
            sectionMap.put("progressPercent", sectionTotal == 0 ? 0 : Math.round(sectionDone * 100.0 / sectionTotal));
            pathData.add(sectionMap);

            totalLessonsAll += sectionTotal;
            completedLessonsAll += sectionDone;
        }

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("totalLessons", totalLessonsAll);
        summary.put("completedLessons", completedLessonsAll);
        summary.put("progressPercent", totalLessonsAll == 0 ? 0
            : Math.round(completedLessonsAll * 100.0 / totalLessonsAll));

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("course", mapCourse(course));
        data.put("path", pathData);
        data.put("summary", summary);
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    // BUG-07 FIX: Moved enrollment endpoints here from EnrollmentResource to fix JAX-RS routing conflict (404)
    @POST
    @Path("/{id}/enroll")
    @Authenticated
    @Transactional
    public Response enroll(@PathParam("id") Long courseId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Course course = Course.findById(courseId);
        if (course == null) return Response.status(404).entity(Map.of("success", false, "message", "Course not found")).build();

        Enrollment e = Enrollment.findByUserAndCourse(userId, courseId);
        if (e == null) {
            e = new Enrollment();
            e.userId = userId;
            e.courseId = courseId;
            e.progressPercent = 0.0;
            e.enrolledAt = LocalDateTime.now();
        }
        e.status = Enrollment.EnrollStatus.ACTIVE;
        e.completedAt = null;
        e.persist();

        return Response.ok(Map.of("success", true, "data", EnrollmentResource.mapEnrollment(e, course), "message", "Enrolled")).build();
    }

    @DELETE
    @Path("/{id}/enroll")
    @Authenticated
    @Transactional
    public Response drop(@PathParam("id") Long courseId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Enrollment e = Enrollment.findByUserAndCourse(userId, courseId);
        if (e == null) return Response.status(404).entity(Map.of("success", false, "message", "Not enrolled")).build();
        e.status = Enrollment.EnrollStatus.DROPPED;
        e.persist();
        return Response.ok(Map.of("success", true, "message", "Enrollment dropped")).build();
    }

    @GET
    @Path("/{id}/enrollment")
    @Authenticated
    public Response getEnrollment(@PathParam("id") Long courseId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Enrollment e = Enrollment.findByUserAndCourse(userId, courseId);
        if (e == null) {
            return Response.ok(Map.of("success", true, "data", null)).build();
        }
        return Response.ok(Map.of("success", true, "data", EnrollmentResource.mapEnrollment(e, Course.findById(courseId)))).build();
    }

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) return Long.parseLong(jwt.getSubject());
        } catch (Exception ignore) {}
        return null;
    }

    private Map<String, Object> mapCourse(Course c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.id);
        m.put("title", c.title);
        m.put("slug", c.slug);
        m.put("description", c.description);
        m.put("levelCode", c.levelCode);
        m.put("certification", c.certification.name());
        m.put("isPremium", c.isPremium);
        m.put("totalUnits", c.totalUnits);
        m.put("estimatedHours", c.estimatedHours);
        m.put("ratingAvg", c.ratingAvg);
        m.put("ratingCount", c.ratingCount);
        return m;
    }
}
