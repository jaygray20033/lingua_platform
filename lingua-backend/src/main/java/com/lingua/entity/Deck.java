package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "decks")
public class Deck extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "owner_id") public Long ownerId;
    public String name;
    public String description;
    @Column(name = "language_id") public Long languageId;
    @Column(name = "is_public") public Boolean isPublic = true;
    @Column(name = "card_count") public Integer cardCount = 0;

    public static List<Deck> findPublicDecks() {
        return list("isPublic = true");
    }
}
