package com.lingua.resource;

import com.lingua.entity.*;
import io.quarkus.security.Authenticated;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;

import java.util.*;
import java.util.stream.Collectors;

@Path("/api/favorites")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class FavoriteResource {

    @Inject JsonWebToken jwt;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @POST
    @Transactional
    public Response add(Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        if (body == null) return Response.status(400).entity(Map.of("success", false, "message", "Body required")).build();

        UserFavorite.ItemType type;
        Long itemId;
        try {
            type = UserFavorite.ItemType.valueOf(String.valueOf(body.get("itemType")).toUpperCase());
            Object idv = body.get("itemId");
            itemId = (idv instanceof Number) ? ((Number) idv).longValue() : Long.parseLong(String.valueOf(idv));
        } catch (Exception e) {
            return Response.status(400).entity(Map.of("success", false, "message", "Invalid itemType or itemId")).build();
        }

        UserFavorite existing = UserFavorite.find(userId, type, itemId);
        if (existing != null) {
            return Response.ok(Map.of("success", true, "data", map(existing), "message", "Already favorited")).build();
        }

        UserFavorite f = new UserFavorite();
        f.userId = userId;
        f.itemType = type;
        f.itemId = itemId;
        f.createdAt = java.time.LocalDateTime.now();
        f.persist();
        return Response.ok(Map.of("success", true, "data", map(f))).build();
    }

    @DELETE
    @Path("/{type}/{itemId}")
    @Transactional
    public Response remove(@PathParam("type") String typeStr, @PathParam("itemId") Long itemId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        UserFavorite.ItemType type;
        try { type = UserFavorite.ItemType.valueOf(typeStr.toUpperCase()); }
        catch (Exception e) { return Response.status(400).entity(Map.of("success", false, "message", "Invalid type")).build(); }

        UserFavorite f = UserFavorite.find(userId, type, itemId);
        if (f == null) return Response.status(404).entity(Map.of("success", false, "message", "Not favorited")).build();
        f.delete();
        return Response.ok(Map.of("success", true, "message", "Removed")).build();
    }

    @GET
    public Response list(@QueryParam("type") String typeStr) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        List<UserFavorite> list;
        if (typeStr != null && !typeStr.isEmpty()) {
            try {
                list = UserFavorite.findByUserAndType(userId, UserFavorite.ItemType.valueOf(typeStr.toUpperCase()));
            } catch (Exception e) {
                return Response.status(400).entity(Map.of("success", false, "message", "Invalid type")).build();
            }
        } else {
            list = UserFavorite.findByUser(userId);
        }

        List<Map<String, Object>> data = list.stream().map(f -> {
            Map<String, Object> m = map(f);
            switch (f.itemType) {
                case WORD: {
                    Word w = Word.findById(f.itemId);
                    if (w != null) m.put("item", Map.of(
                        "id", w.id,
                        "text", w.text != null ? w.text : "",
                        "reading", w.reading != null ? w.reading : "",
                        "pos", w.pos != null ? w.pos : ""
                    ));
                    break;
                }
                case CHARACTER: {
                    CharacterEntity c = CharacterEntity.findById(f.itemId);
                    if (c != null) m.put("item", Map.of(
                        "id", c.id,
                        "character", c.characterText != null ? c.characterText : "",
                        "hanViet", c.hanViet != null ? c.hanViet : "",
                        "meaningVi", c.meaningVi != null ? c.meaningVi : ""
                    ));
                    break;
                }
                case GRAMMAR: {
                    Grammar g = Grammar.findById(f.itemId);
                    if (g != null) m.put("item", Map.of(
                        "id", g.id,
                        "pattern", g.pattern != null ? g.pattern : "",
                        "meaningVi", g.meaningVi != null ? g.meaningVi : ""
                    ));
                    break;
                }
            }
            return m;
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/check")
    public Response check(@QueryParam("type") String typeStr, @QueryParam("id") Long itemId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        if (typeStr == null || itemId == null) {
            return Response.status(400).entity(Map.of("success", false, "message", "type and id required")).build();
        }
        UserFavorite.ItemType type;
        try { type = UserFavorite.ItemType.valueOf(typeStr.toUpperCase()); }
        catch (Exception e) { return Response.status(400).entity(Map.of("success", false, "message", "Invalid type")).build(); }

        UserFavorite f = UserFavorite.find(userId, type, itemId);
        return Response.ok(Map.of("success", true, "data", Map.of("favorited", f != null))).build();
    }

    private Map<String, Object> map(UserFavorite f) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", f.id);
        m.put("itemType", f.itemType.name());
        m.put("itemId", f.itemId);
        m.put("createdAt", f.createdAt != null ? f.createdAt.toString() : null);
        return m;
    }
}
