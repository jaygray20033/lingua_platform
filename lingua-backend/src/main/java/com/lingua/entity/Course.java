package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "courses")
public class Course extends PanacheEntityBase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    public String title;
    public String slug;
    public String description;

    @Column(name = "source_lang_id")
    public Long sourceLangId;

    @Column(name = "target_lang_id")
    public Long targetLangId;

    @Column(name = "level_code")
    public String levelCode;

    @Enumerated(EnumType.STRING)
    public Certification certification = Certification.NONE;

    @Column(name = "is_premium")
    public Boolean isPremium = false;

    @Column(name = "thumbnail_url")
    public String thumbnailUrl;

    @Column(name = "author_id")
    public Long authorId;

    @Enumerated(EnumType.STRING)
    public CourseStatus status = CourseStatus.PUBLISHED;

    @Column(name = "total_units")
    public Integer totalUnits = 0;

    @Column(name = "estimated_hours")
    public Integer estimatedHours = 0;

    @Column(name = "rating_avg")
    public Double ratingAvg = 0.0;

    @Column(name = "rating_count")
    public Integer ratingCount = 0;

    @Column(name = "created_at")
    public LocalDateTime createdAt = LocalDateTime.now();

    public enum Certification { JLPT, TOPIK, CEFR, HSK, IELTS, NONE }
    public enum CourseStatus { DRAFT, PENDING_REVIEW, PUBLISHED, ARCHIVED }

    public static List<Course> findByLanguage(Long targetLangId) {
        return list("targetLangId = ?1 and status = 'PUBLISHED'", targetLangId);
    }

    public static List<Course> findPublished() {
        return list("status", CourseStatus.PUBLISHED);
    }
}
