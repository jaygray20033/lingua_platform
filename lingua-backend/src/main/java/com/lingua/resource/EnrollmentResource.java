package com.lingua.resource;

import com.lingua.entity.*;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.*;
import java.util.stream.Collectors;

/**
 * BUG-07 FIX: Removed POST/DELETE /courses/{id}/enroll and GET /courses/{id}/enrollment from this resource
 * because they collided with @Path("/api/courses") in CourseResource (JAX-RS routing conflict caused 404).
 * Those endpoints are now defined inside CourseResource. Only GET /api/enrollments remains here.
 */
@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EnrollmentResource {

    @Inject JsonWebToken jwt;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @GET
    @Path("/enrollments")
    @Authenticated
    public Response listMine() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        List<Enrollment> enrolls = Enrollment.list("userId = ?1 order by enrolledAt desc", userId);
        List<Map<String, Object>> data = enrolls.stream().map(e -> {
            Course c = Course.findById(e.courseId);
            return mapEnrollment(e, c);
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    static Map<String, Object> mapEnrollment(Enrollment e, Course c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.id);
        m.put("userId", e.userId);
        m.put("courseId", e.courseId);
        m.put("status", e.status != null ? e.status.name() : "ACTIVE");
        m.put("progressPercent", e.progressPercent);
        m.put("enrolledAt", e.enrolledAt != null ? e.enrolledAt.toString() : null);
        m.put("completedAt", e.completedAt != null ? e.completedAt.toString() : null);
        if (c != null) {
            Map<String, Object> cm = new LinkedHashMap<>();
            cm.put("id", c.id);
            cm.put("title", c.title);
            cm.put("levelCode", c.levelCode);
            cm.put("certification", c.certification != null ? c.certification.name() : null);
            cm.put("totalUnits", c.totalUnits);
            m.put("course", cm);
        }
        return m;
    }
}
