package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "sections")
public class Section extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "course_id") public Long courseId;
    @Column(name = "order_index") public Integer orderIndex;
    public String title;
    public String description;
    @Column(name = "cefr_mapping") public String cefrMapping;

    public static List<Section> findByCourse(Long courseId) {
        return list("courseId = ?1 order by orderIndex", courseId);
    }
}
