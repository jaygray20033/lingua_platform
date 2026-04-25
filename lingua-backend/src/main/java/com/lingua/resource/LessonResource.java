package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class LessonResource {

    @GET
    @Path("/lessons/{id}")
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
}
