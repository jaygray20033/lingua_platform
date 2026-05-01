package com.lingua.resource;

import com.lingua.entity.*;
import com.lingua.service.SRSService;
import io.quarkus.security.Authenticated;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.jwt.JsonWebToken;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/srs")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class SRSResource {

    @Inject
    SRSService srsService;

    @Inject
    JsonWebToken jwt;

    @Inject
    com.lingua.service.QuestService questService;

    private Long currentUserId() {
        try {
            if (jwt != null && jwt.getSubject() != null) {
                return Long.parseLong(jwt.getSubject());
            }
        } catch (Exception ignore) {}
        return null;
    }

    @GET
    @Path("/due")
    @Authenticated
    public Response getDueCards(@QueryParam("limit") @DefaultValue("100") int limit) {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }

        limit = Math.max(1, Math.min(limit, 200));

        List<FlashcardReview> reviews = FlashcardReview.findDue(userId, limit);

        List<Map<String, Object>> data = reviews.stream().limit(limit).map(r -> {
            Card card = Card.findById(r.cardId);
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("reviewId", r.id);
            m.put("cardId", r.cardId);
            m.put("state", r.state.name());
            m.put("easeFactor", r.easeFactor);
            m.put("intervalDays", r.intervalDays);
            m.put("repetitions", r.repetitions);
            if (card != null) {
                m.put("front", card.frontText);
                m.put("back", card.backText);
            }
            return m;
        }).collect(Collectors.toList());

        return Response.ok(Map.of("success", true, "data", data, "count", data.size())).build();
    }

    @POST
    @Path("/{reviewId}/review")
    @Authenticated
    @Transactional
    public Response reviewCard(@PathParam("reviewId") Long reviewId, Map<String, String> body) {
        Long userId = currentUserId();
        if (userId == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Unauthorized")).build();
        }
        String rating = body != null ? body.get("rating") : null;
        if (rating == null) return Response.status(400).entity(Map.of("success", false, "message", "rating is required")).build();

        FlashcardReview review = FlashcardReview.findById(reviewId);
        if (review == null) return Response.status(404).build();

        if (review.userId != null && !review.userId.equals(userId)) {
            return Response.status(403).entity(Map.of("success", false, "message", "Forbidden")).build();
        }

        srsService.processReview(review, rating);

        try { questService.bumpCategory(userId, "SRS", 1); } catch (Exception ignore) {}

        return Response.ok(Map.of(
            "success", true,
            "data", Map.of(
                "nextReviewAt", review.nextReviewAt.toString(),
                "intervalDays", review.intervalDays,
                "easeFactor", review.easeFactor,
                "state", review.state.name()
            )
        )).build();
    }

    @GET
    @Path("/decks")
    @PermitAll
    public Response listDecks() {
        List<Deck> decks = Deck.findPublicDecks();
        List<Map<String, Object>> data = decks.stream().map(d -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", d.id);
            m.put("name", d.name);
            m.put("description", d.description);
            m.put("cardCount", d.cardCount);
            m.put("languageId", d.languageId);
            return m;
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/decks/{id}/cards")
    @PermitAll
    public Response getDeckCards(@PathParam("id") Long deckId) {
        List<Card> cards = Card.findByDeck(deckId);
        List<Map<String, Object>> data = cards.stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.id);
            m.put("front", c.frontText);
            m.put("back", c.backText);
            return m;
        }).collect(Collectors.toList());
        return Response.ok(Map.of("success", true, "data", data)).build();
    }
}
