package com.lingua.resource;

import com.lingua.entity.*;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/mock-tests")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MockTestResource {

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
    public Response listMockTests(
        @QueryParam("cert") String cert,
        @QueryParam("level") String level) {

        List<MockTest> tests;
        if (cert != null) tests = MockTest.findByCert(cert, level);
        else tests = MockTest.listAll();

        List<Map<String, Object>> data = tests.stream().map(t -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", t.id);
            m.put("title", t.title);
            m.put("certification", t.certification);
            m.put("levelCode", t.levelCode);
            m.put("totalDurationMin", t.totalDurationMin);
            m.put("passScore", t.passScore);
            m.put("sectionConfig", t.sectionConfigJson);
            return m;
        }).collect(Collectors.toList());

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}")
    public Response getMockTest(@PathParam("id") Long id) {
        MockTest test = MockTest.findById(id);
        if (test == null) return Response.status(404).build();

        List<MockTestQuestion> questions = MockTestQuestion.findByTest(id);

        Map<String, List<Map<String, Object>>> sections = new LinkedHashMap<>();
        for (MockTestQuestion q : questions) {
            sections.computeIfAbsent(q.section, k -> new ArrayList<>());
            Map<String, Object> qm = new LinkedHashMap<>();
            qm.put("id", q.id);
            qm.put("section", q.section);
            qm.put("questionJson", q.questionJson);
            qm.put("answerJson", q.answerJson);
            qm.put("difficulty", q.difficulty);
            qm.put("orderIndex", q.orderIndex);
            sections.get(q.section).add(qm);
        }

        return Response.ok(Map.of(
            "success", true,
            "data", Map.of(
                "id", test.id,
                "title", test.title,
                "certification", test.certification,
                "levelCode", test.levelCode,
                "totalDurationMin", test.totalDurationMin,
                "passScore", test.passScore,
                "sectionConfig", test.sectionConfigJson,
                "sections", sections
            )
        )).build();
    }

    @POST
    @Path("/{id}/submit")
    @Authenticated
    @Transactional
    public Response submitAttempt(@PathParam("id") Long testId, Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        MockTest test = MockTest.findById(testId);
        if (test == null) {
            return Response.status(404).entity(Map.of("success", false, "message", "Mock test not found")).build();
        }

        Map<String, Object> b = body != null ? body : Map.of();
        int scoreTotal = toInt(b.get("scoreTotal"), 0);
        boolean passed = b.get("passed") instanceof Boolean ? (Boolean) b.get("passed")
                       : scoreTotal >= (test.passScore != null ? test.passScore : 60);
        int durationSec = toInt(b.get("durationSec"), 0);

        Object sectionsObj = b.get("scoreBySection");
        String sectionsJson = sectionsObj == null ? "{}" : sectionsObj.toString();

        if (sectionsObj instanceof Map<?, ?>) {
            sectionsJson = mapToJson((Map<?, ?>) sectionsObj);
        }

        MockTestAttempt attempt = new MockTestAttempt();
        attempt.userId = userId;
        attempt.mockTestId = testId;
        attempt.scoreTotal = scoreTotal;
        attempt.scoreBySectionJson = sectionsJson;
        attempt.passed = passed;
        attempt.durationSec = durationSec;
        attempt.startedAt = LocalDateTime.now().minusSeconds(Math.max(0, durationSec));
        attempt.submittedAt = LocalDateTime.now();
        attempt.persist();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("attemptId", attempt.id);
        data.put("mockTestId", testId);
        data.put("scoreTotal", scoreTotal);
        data.put("passed", passed);
        data.put("durationSec", durationSec);
        return Response.ok(Map.of("success", true, "data", data, "message", "Attempt saved")).build();
    }

    @GET
    @Path("/attempts")
    @Authenticated
    public Response listMyAttempts(@QueryParam("testId") Long testId) {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        List<MockTestAttempt> attempts = testId != null
            ? MockTestAttempt.findByUserAndTest(userId, testId)
            : MockTestAttempt.findByUser(userId);
        List<Map<String, Object>> data = attempts.stream().map(a -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", a.id);
            m.put("mockTestId", a.mockTestId);
            m.put("scoreTotal", a.scoreTotal);
            m.put("scoreBySection", a.scoreBySectionJson);
            m.put("passed", a.passed);
            m.put("durationSec", a.durationSec);
            m.put("submittedAt", a.submittedAt);
            return m;
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    private static int toInt(Object v, int fallback) {
        if (v == null) return fallback;
        if (v instanceof Number) return ((Number) v).intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return fallback; }
    }

    private static String mapToJson(Map<?, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<?, ?> e : map.entrySet()) {
            if (!first) sb.append(",");
            first = false;
            sb.append('"').append(escape(String.valueOf(e.getKey()))).append('"').append(':');
            Object v = e.getValue();
            if (v instanceof Number || v instanceof Boolean) {
                sb.append(v.toString());
            } else if (v instanceof Map<?, ?>) {
                sb.append(mapToJson((Map<?, ?>) v));
            } else if (v == null) {
                sb.append("null");
            } else {
                sb.append('"').append(escape(v.toString())).append('"');
            }
        }
        sb.append("}");
        return sb.toString();
    }

    private static String escape(String s) {
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
