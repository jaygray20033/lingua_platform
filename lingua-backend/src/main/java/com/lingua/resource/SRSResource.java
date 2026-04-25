package com.lingua.resource;

import com.lingua.entity.*;
import com.lingua.service.SRSService;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/srs")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class SRSResource {

    @Inject
    SRSService srsService;

    @GET
    @Path("/due")
    public Response getDueCards(@QueryParam("userId") @DefaultValue("2") Long userId,
                                 @QueryParam("limit") @DefaultValue("100") int limit) {
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
    @Transactional
    public Response reviewCard(@PathParam("reviewId") Long reviewId, Map<String, String> body) {
        String rating = body.get("rating"); // AGAIN, HARD, GOOD, EASY
        if (rating == null) return Response.status(400).build();

        FlashcardReview review = FlashcardReview.findById(reviewId);
        if (review == null) return Response.status(404).build();

        srsService.processReview(review, rating);

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
