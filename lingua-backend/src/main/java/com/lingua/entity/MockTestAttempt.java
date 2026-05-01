package com.lingua.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "mock_test_attempts")
public class MockTestAttempt extends PanacheEntityBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    @Column(name = "user_id") public Long userId;
    @Column(name = "mock_test_id") public Long mockTestId;
    @Column(name = "score_total") public Integer scoreTotal;
    @Column(name = "score_by_section_json", columnDefinition = "JSON") public String scoreBySectionJson;
    public Boolean passed = false;
    @Column(name = "duration_sec") public Integer durationSec = 0;
    @Column(name = "started_at") public LocalDateTime startedAt = LocalDateTime.now();
    @Column(name = "submitted_at") public LocalDateTime submittedAt;

    public static List<MockTestAttempt> findByUser(Long userId) {
        return list("userId = ?1 order by submittedAt desc", userId);
    }

    public static List<MockTestAttempt> findByUserAndTest(Long userId, Long testId) {
        return list("userId = ?1 and mockTestId = ?2 order by submittedAt desc", userId, testId);
    }
}
