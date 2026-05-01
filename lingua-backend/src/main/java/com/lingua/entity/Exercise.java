package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "exercises")
public class Exercise extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "lesson_id") public Long lessonId;
    @Column(name = "order_index") public Integer orderIndex;
    @Column(name = "type") public String type;
    @Column(name = "prompt_json", columnDefinition = "JSON") public String promptJson;
    @Column(name = "answer_json", columnDefinition = "JSON") public String answerJson;
    @Column(name = "hint_json", columnDefinition = "JSON") public String hintJson;
    @Column(name = "audio_url") public String audioUrl;
    @Column(name = "image_url") public String imageUrl;
    public Integer difficulty = 1;

    public static List<Exercise> findByLesson(Long lessonId) {
        return list("lessonId = ?1 order by orderIndex", lessonId);
    }
}
