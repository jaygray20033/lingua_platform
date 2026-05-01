package com.lingua.resource;

import com.lingua.entity.DailyQuest;
import com.lingua.entity.QuestTemplate;
import com.lingua.service.QuestService;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.*;

@Path("/api/quests")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class QuestResource {

    @Inject JsonWebToken jwt;
    @Inject QuestService questService;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @GET
    @Path("/today")
    @Authenticated
    public Response getToday() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        List<DailyQuest> quests = questService.rollForUser(userId);

        Map<Long, QuestTemplate> templates = new HashMap<>();
        for (QuestTemplate t : QuestTemplate.<QuestTemplate>listAll()) templates.put(t.id, t);

        List<Map<String, Object>> data = new ArrayList<>();
        for (DailyQuest q : quests) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", q.id);
            m.put("code", q.questCode);
            m.put("title", q.description);
            m.put("target", q.target);
            m.put("progress", q.progress);
            m.put("rewardGems", q.rewardGems);
            m.put("rewardXp", q.rewardXp);
            m.put("completed", Boolean.TRUE.equals(q.completed));
            m.put("claimed", Boolean.TRUE.equals(q.claimed));
            QuestTemplate t = templates.get(q.templateId);
            if (t != null) {
                m.put("icon", t.icon);
                m.put("category", t.category);
                m.put("description", t.description);
            }
            data.add(m);
        }
        return Response.ok(Map.of(
            "success", true,
            "data", data,
            "completedCount", data.stream().filter(m -> Boolean.TRUE.equals(m.get("completed"))).count(),
            "totalCount", data.size()
        )).build();
    }

    @POST
    @Path("/{id}/claim")
    @Authenticated
    public Response claim(@PathParam("id") Long questId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        try {
            Map<String, Object> r = questService.claim(userId, questId);
            return Response.ok(Map.of("success", true, "data", r, "message", "Quest reward claimed")).build();
        } catch (IllegalArgumentException e) {
            return Response.status(404).entity(Map.of("success", false, "message", e.getMessage())).build();
        } catch (IllegalStateException e) {
            return Response.status(400).entity(Map.of("success", false, "message", e.getMessage())).build();
        }
    }

    @POST
    @Path("/event")
    @Authenticated
    public Response progressEvent(Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        if (body == null) return Response.status(400).entity(Map.of("success", false, "message", "Body required")).build();
        String category = String.valueOf(body.getOrDefault("category", "")).toUpperCase(Locale.ROOT);
        int amount = 1;
        try { amount = Math.max(1, Math.min(100, Integer.parseInt(String.valueOf(body.getOrDefault("amount", 1))))); } catch (Exception ignore) {}
        List<String> done = questService.bumpCategory(userId, category, amount);
        return Response.ok(Map.of("success", true, "data", Map.of("completed", done))).build();
    }
}
