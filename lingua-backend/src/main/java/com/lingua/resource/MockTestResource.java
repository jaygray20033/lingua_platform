package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/mock-tests")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MockTestResource {

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
}
