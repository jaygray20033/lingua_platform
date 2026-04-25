package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "cards")
public class Card extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "deck_id") public Long deckId;
    @Column(name = "front_text") public String frontText;
    @Column(name = "back_text") public String backText;
    @Column(name = "audio_url") public String audioUrl;
    @Column(name = "ref_word_id") public Long refWordId;
    @Column(name = "ref_character_id") public Long refCharacterId;

    public static List<Card> findByDeck(Long deckId) {
        return list("deckId", deckId);
    }
}
