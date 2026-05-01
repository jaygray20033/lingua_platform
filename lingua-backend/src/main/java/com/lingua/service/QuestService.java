package com.lingua.service;

import com.lingua.entity.*;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.time.LocalDate;
import java.util.*;

@ApplicationScoped
public class QuestService {

    public static final int QUESTS_PER_DAY = 3;

    @Inject GamificationService gamificationService;

    @Transactional
    public List<DailyQuest> rollForUser(Long userId) {
        if (userId == null) return Collections.emptyList();
        LocalDate today = LocalDate.now();
        List<DailyQuest> existing = DailyQuest.findForDate(userId, today);
        if (!existing.isEmpty()) return existing;

        List<QuestTemplate> templates = QuestTemplate.findEnabled();
        if (templates.isEmpty()) return Collections.emptyList();

        long seed = Objects.hash(userId, today.toString());
        Random rng = new Random(seed);
        List<QuestTemplate> shuffled = new ArrayList<>(templates);
        Collections.shuffle(shuffled, rng);

        List<DailyQuest> created = new ArrayList<>();
        for (int i = 0; i < Math.min(QUESTS_PER_DAY, shuffled.size()); i++) {
            QuestTemplate t = shuffled.get(i);
            DailyQuest q = new DailyQuest();
            q.userId = userId;
            q.questCode = t.code;
            q.templateId = t.id;
            q.description = t.title;
            q.target = t.targetCount != null ? t.targetCount : 1;
            q.progress = 0;
            q.rewardGems = t.rewardGems != null ? t.rewardGems : 5;
            q.rewardXp = t.rewardXp != null ? t.rewardXp : 5;
            q.completed = false;
            q.claimed = false;
            q.questDate = today;
            q.persist();
            created.add(q);
        }
        return created;
    }

    @Transactional
    public List<String> bumpCategory(Long userId, String category, int amount) {
        if (userId == null || amount <= 0) return Collections.emptyList();
        List<DailyQuest> todays = rollForUser(userId);
        List<String> justCompleted = new ArrayList<>();

        Map<Long, String> catMap = new HashMap<>();
        for (QuestTemplate t : QuestTemplate.<QuestTemplate>listAll()) {
            catMap.put(t.id, t.category);
        }

        for (DailyQuest q : todays) {
            if (Boolean.TRUE.equals(q.completed)) continue;
            String c = catMap.getOrDefault(q.templateId, "");
            if (!c.equalsIgnoreCase(category)) continue;
            int before = q.progress == null ? 0 : q.progress;
            int after = Math.min(q.target, before + amount);
            q.progress = after;
            if (after >= q.target && !Boolean.TRUE.equals(q.completed)) {
                q.completed = true;
                justCompleted.add(q.questCode);
            }
            q.persist();
        }
        return justCompleted;
    }

    @Transactional
    public List<String> syncXpToday(Long userId, int xpToday) {
        if (userId == null) return Collections.emptyList();
        List<DailyQuest> todays = rollForUser(userId);
        Map<Long, String> catMap = new HashMap<>();
        for (QuestTemplate t : QuestTemplate.<QuestTemplate>listAll()) {
            catMap.put(t.id, t.category);
        }
        List<String> justCompleted = new ArrayList<>();
        for (DailyQuest q : todays) {
            String c = catMap.getOrDefault(q.templateId, "");
            if (!"XP".equalsIgnoreCase(c)) continue;
            int newProg = Math.min(q.target, xpToday);
            if (newProg != (q.progress == null ? 0 : q.progress)) q.progress = newProg;
            if (q.progress >= q.target && !Boolean.TRUE.equals(q.completed)) {
                q.completed = true;
                justCompleted.add(q.questCode);
                q.persist();
            }
        }
        return justCompleted;
    }

    @Transactional
    public Map<String, Object> claim(Long userId, Long questId) {
        DailyQuest q = DailyQuest.findById(questId);
        if (q == null || !q.userId.equals(userId)) {
            throw new IllegalArgumentException("Quest not found");
        }
        if (!Boolean.TRUE.equals(q.completed)) {
            throw new IllegalStateException("Quest not completed");
        }
        if (Boolean.TRUE.equals(q.claimed)) {
            throw new IllegalStateException("Already claimed");
        }
        q.claimed = true;
        q.persist();

        UserGamification gam = gamificationService.ensure(userId);
        gam.gems = (gam.gems == null ? 0 : gam.gems) + (q.rewardGems == null ? 0 : q.rewardGems);
        gam.persist();

        if (q.rewardXp != null && q.rewardXp > 0) {
            gam = gamificationService.awardXp(userId, q.rewardXp);
        }

        Map<String, Object> r = new LinkedHashMap<>();
        r.put("rewardXp", q.rewardXp);
        r.put("rewardGems", q.rewardGems);
        r.put("totalXp", gam.totalXp);
        r.put("gems", gam.gems);
        r.put("level", gam.level);
        return r;
    }
}
