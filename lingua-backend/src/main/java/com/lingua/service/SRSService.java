package com.lingua.service;

import com.lingua.entity.FlashcardReview;
import com.lingua.entity.FlashcardReview.SRSState;
import jakarta.enterprise.context.ApplicationScoped;
import java.time.LocalDateTime;

/**
 * SM-2 Spaced Repetition Algorithm Implementation
 * Based on the SuperMemo-2 algorithm by Piotr Wozniak
 */
@ApplicationScoped
public class SRSService {

    public void processReview(FlashcardReview review, String ratingStr) {
        int ratingValue;
        switch (ratingStr.toUpperCase()) {
            case "AGAIN": ratingValue = 1; break;
            case "HARD": ratingValue = 2; break;
            case "GOOD": ratingValue = 3; break;
            case "EASY": ratingValue = 5; break;
            default: ratingValue = 3;
        }

        if (ratingStr.equalsIgnoreCase("AGAIN")) {
            // Forgot completely - reset
            review.repetitions = 0;
            review.intervalDays = 1;
            review.easeFactor = Math.max(1.3, review.easeFactor - 0.2);
            review.lapses = review.lapses + 1;
            review.state = SRSState.RELEARNING;
        } else {
            if (review.repetitions == 0) {
                review.intervalDays = 1;
            } else if (review.repetitions == 1) {
                review.intervalDays = 6;
            } else {
                review.intervalDays = (int) Math.round(review.intervalDays * review.easeFactor);
            }
            review.repetitions += 1;

            // Update ease factor
            double ef = review.easeFactor + (0.1 - (5 - ratingValue) * (0.08 + (5 - ratingValue) * 0.02));
            review.easeFactor = Math.max(1.3, ef);

            // Adjust interval for HARD
            if (ratingStr.equalsIgnoreCase("HARD")) {
                review.intervalDays = (int) Math.max(1, review.intervalDays * 0.8);
            }
            // Bonus for EASY
            if (ratingStr.equalsIgnoreCase("EASY")) {
                review.intervalDays = (int) (review.intervalDays * 1.3);
            }

            review.state = SRSState.REVIEW;
        }

        review.nextReviewAt = LocalDateTime.now().plusDays(review.intervalDays);
        review.lastReviewedAt = LocalDateTime.now();
        review.persist();
    }
}
