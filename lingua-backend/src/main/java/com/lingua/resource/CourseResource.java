package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/courses")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CourseResource {

    @GET
    public Response listCourses(
        @QueryParam("language") String language,
        @QueryParam("level") String level,
        @QueryParam("certification") String cert) {

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

        List<Map<String, Object>> data = courses.stream().map(this::mapCourse).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}")
    public Response getCourse(@PathParam("id") Long id) {
        Course course = Course.findById(id);
        if (course == null) return Response.status(404).entity(Map.of("success", false, "message", "Course not found")).build();

        Map<String, Object> data = mapCourse(course);
        // Add language info
        Language targetLang = Language.findById(course.targetLangId);
        Language sourceLang = Language.findById(course.sourceLangId);
        data.put("targetLanguage", targetLang != null ? Map.of("code", targetLang.code, "name", targetLang.name, "flagEmoji", targetLang.flagEmoji) : null);
        data.put("sourceLanguage", sourceLang != null ? Map.of("code", sourceLang.code, "name", sourceLang.name) : null);

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}/path")
    public Response getCoursePath(@PathParam("id") Long id) {
        Course course = Course.findById(id);
        if (course == null) return Response.status(404).build();

        List<Section> sections = Section.findByCourse(id);
        List<Map<String, Object>> pathData = new ArrayList<>();

        for (Section section : sections) {
            Map<String, Object> sectionMap = new LinkedHashMap<>();
            sectionMap.put("id", section.id);
            sectionMap.put("title", section.title);
            sectionMap.put("description", section.description);
            sectionMap.put("orderIndex", section.orderIndex);

            List<Unit> units = Unit.findBySection(section.id);
            List<Map<String, Object>> unitsList = new ArrayList<>();

            for (Unit unit : units) {
                Map<String, Object> unitMap = new LinkedHashMap<>();
                unitMap.put("id", unit.id);
                unitMap.put("title", unit.title);
                unitMap.put("icon", unit.icon);
                unitMap.put("communicationGoal", unit.communicationGoal);
                unitMap.put("xpReward", unit.xpReward);

                List<Lesson> lessons = Lesson.findByUnit(unit.id);
                List<Map<String, Object>> lessonsList = lessons.stream().map(l -> {
                    Map<String, Object> lm = new LinkedHashMap<>();
                    lm.put("id", l.id);
                    lm.put("title", l.title);
                    lm.put("type", l.type.name());
                    lm.put("xpReward", l.xpReward);
                    lm.put("exerciseCount", l.exerciseCount);
                    return lm;
                }).collect(Collectors.toList());

                unitMap.put("lessons", lessonsList);
                unitsList.add(unitMap);
            }
            sectionMap.put("units", unitsList);
            pathData.add(sectionMap);
        }

        return Response.ok(Map.of("success", true, "data", Map.of("course", mapCourse(course), "path", pathData))).build();
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
