package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;

@Path("/api/gamification")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class GamificationResource {

    @GET
    @Path("/me")
    public Response getGamification(@QueryParam("userId") @DefaultValue("2") Long userId) {
        UserGamification gam = UserGamification.findByUser(userId);
        if (gam == null) return Response.status(404).build();

        User user = User.findById(userId);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("userId", userId);
        data.put("displayName", user != null ? user.displayName : "");
        data.put("totalXp", gam.totalXp);
        data.put("level", gam.level);
        data.put("gems", gam.gems);
        data.put("hearts", gam.hearts);
        data.put("streakCount", gam.streakCount);
        data.put("longestStreak", gam.longestStreak);
        data.put("lastStreakDate", gam.lastStreakDate);
        data.put("streakFreezeCount", gam.streakFreezeCount);

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/achievements")
    public Response listAchievements() {
        List<Object[]> achievements = Achievement.listAll().stream()
            .map(a -> new Object[]{a})
            .collect(java.util.stream.Collectors.toList());

        List<Map<String, Object>> data = new ArrayList<>();
        for (Object obj : Achievement.listAll()) {
            Achievement a = (Achievement) obj;
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", a.id);
            m.put("code", a.code);
            m.put("title", a.title);
            m.put("description", a.description);
            m.put("rarity", a.rarity);
            data.add(m);
        }

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/languages")
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
