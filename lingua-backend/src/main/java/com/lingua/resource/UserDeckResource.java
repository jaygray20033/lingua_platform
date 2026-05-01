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

@Path("/api/my-decks")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@Authenticated
public class UserDeckResource {

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
    public Response listMine() {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        List<Deck> decks = Deck.list("ownerId = ?1", userId);
        List<Map<String, Object>> data = decks.stream().map(this::mapDeck).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @POST
    @Transactional
    public Response create(Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        if (body == null) return Response.status(400).entity(Map.of("success", false, "message", "Body required")).build();

        String name = asString(body.get("name"));
        if (name == null || name.isBlank())
            return Response.status(400).entity(Map.of("success", false, "message", "name is required")).build();

        Deck d = new Deck();
        d.ownerId = userId;
        d.name = name.trim();
        d.description = asString(body.get("description"));
        d.isPublic = Boolean.TRUE.equals(body.get("isPublic"));
        Object lid = body.get("languageId");
        if (lid instanceof Number) d.languageId = ((Number) lid).longValue();
        d.cardCount = 0;
        d.persist();
        return Response.ok(Map.of("success", true, "data", mapDeck(d))).build();
    }

    @DELETE
    @Path("/{deckId}")
    @Transactional
    public Response remove(@PathParam("deckId") Long deckId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Deck d = Deck.findById(deckId);
        if (d == null) return Response.status(404).entity(Map.of("success", false, "message", "Deck not found")).build();
        if (d.ownerId == null || !d.ownerId.equals(userId))
            return Response.status(403).entity(Map.of("success", false, "message", "Forbidden")).build();

        List<Card> cards = Card.findByDeck(deckId);
        for (Card c : cards) {
            FlashcardReview.delete("cardId", c.id);
            c.delete();
        }
        d.delete();
        return Response.ok(Map.of("success", true, "message", "Deck deleted")).build();
    }

    @POST
    @Path("/{deckId}/cards")
    @Transactional
    public Response addCard(@PathParam("deckId") Long deckId, Map<String, Object> body) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Deck d = Deck.findById(deckId);
        if (d == null) return Response.status(404).entity(Map.of("success", false, "message", "Deck not found")).build();
        if (d.ownerId == null || !d.ownerId.equals(userId))
            return Response.status(403).entity(Map.of("success", false, "message", "Forbidden")).build();

        String front = asString(body != null ? body.get("front") : null);
        String back  = asString(body != null ? body.get("back")  : null);
        if (front == null || back == null || front.isBlank() || back.isBlank())
            return Response.status(400).entity(Map.of("success", false, "message", "front and back are required")).build();

        Card c = new Card();
        c.deckId = deckId;
        c.frontText = front.trim();
        c.backText  = back.trim();
        c.audioUrl  = asString(body != null ? body.get("audioUrl") : null);
        c.persist();

        d.cardCount = (d.cardCount == null ? 0 : d.cardCount) + 1;
        d.persist();

        return Response.ok(Map.of("success", true, "data", mapCard(c))).build();
    }

    @DELETE
    @Path("/{deckId}/cards/{cardId}")
    @Transactional
    public Response removeCard(@PathParam("deckId") Long deckId, @PathParam("cardId") Long cardId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Deck d = Deck.findById(deckId);
        if (d == null) return Response.status(404).entity(Map.of("success", false, "message", "Deck not found")).build();
        if (d.ownerId == null || !d.ownerId.equals(userId))
            return Response.status(403).entity(Map.of("success", false, "message", "Forbidden")).build();

        Card c = Card.findById(cardId);
        if (c == null || !Objects.equals(c.deckId, deckId))
            return Response.status(404).entity(Map.of("success", false, "message", "Card not found")).build();

        FlashcardReview.delete("cardId", cardId);
        c.delete();
        d.cardCount = Math.max(0, (d.cardCount == null ? 1 : d.cardCount) - 1);
        d.persist();
        return Response.ok(Map.of("success", true, "message", "Removed")).build();
    }

    @POST
    @Path("/{deckId}/start")
    @Transactional
    public Response startStudying(@PathParam("deckId") Long deckId) {
        Long userId = currentUserId();
        if (userId == null) return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();

        Deck d = Deck.findById(deckId);
        if (d == null) return Response.status(404).entity(Map.of("success", false, "message", "Deck not found")).build();

        if (!(Boolean.TRUE.equals(d.isPublic) || Objects.equals(d.ownerId, userId)))
            return Response.status(403).entity(Map.of("success", false, "message", "Forbidden")).build();

        List<Card> cards = Card.findByDeck(deckId);
        int created = 0;
        for (Card c : cards) {
            FlashcardReview existing = FlashcardReview.find(
                "userId = ?1 and cardId = ?2", userId, c.id).firstResult();
            if (existing != null) continue;
            FlashcardReview r = new FlashcardReview();
            r.userId = userId;
            r.cardId = c.id;
            r.state = FlashcardReview.SRSState.NEW;
            r.easeFactor = 2.5;
            r.intervalDays = 0;
            r.repetitions = 0;
            r.lapses = 0;
            r.nextReviewAt = LocalDateTime.now();
            r.persist();
            created++;
        }
        return Response.ok(Map.of("success", true, "data", Map.of("createdReviews", created, "totalCards", cards.size()))).build();
    }

    private Map<String, Object> mapDeck(Deck d) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.id);
        m.put("name", d.name);
        m.put("description", d.description);
        m.put("cardCount", d.cardCount);
        m.put("languageId", d.languageId);
        m.put("isPublic", d.isPublic);
        m.put("ownerId", d.ownerId);
        return m;
    }

    private Map<String, Object> mapCard(Card c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.id);
        m.put("deckId", c.deckId);
        m.put("front", c.frontText);
        m.put("back", c.backText);
        m.put("audioUrl", c.audioUrl);
        return m;
    }

    private String asString(Object o) { return o == null ? null : String.valueOf(o); }
}
