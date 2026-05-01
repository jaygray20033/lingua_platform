package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.annotation.security.PermitAll;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api/grammars")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@PermitAll
public class GrammarResource {

    @GET
    public Response listGrammars(
        @QueryParam("lang") String lang,
        @QueryParam("level") String level,
        @QueryParam("q") String query) {

        StringBuilder qb = new StringBuilder("1=1");
        List<Object> params = new ArrayList<>();
        int idx = 1;
        if (lang != null) {
            Language language = Language.findByCode(lang);
            if (language != null) {
                qb.append(" and languageId = ?" + (idx++));
                params.add(language.id);
            } else {
                return Response.ok(Map.of("success", true, "data", new ArrayList<>())).build();
            }
        }
        if (level != null) {
            qb.append(" and (jlptLevel = ?" + idx + " or cefrLevel = ?" + idx + " or hskLevel = ?" + idx + ")");
            params.add(level);
            idx++;
        }
        if (query != null && !query.isEmpty()) {
            qb.append(" and (pattern like ?" + idx + " or meaningVi like ?" + idx + ")");
            params.add("%" + query + "%");
            idx++;
        }

        List<Grammar> grammars;
        if (params.isEmpty()) {
            grammars = Grammar.listAll();
        } else {
            grammars = Grammar.list(qb.toString() + " order by jlptLevel, hskLevel, cefrLevel, id", params.toArray());
        }

        List<Map<String, Object>> data = grammars.stream().map(g -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", g.id);
            m.put("pattern", g.pattern);
            m.put("meaningVi", g.meaningVi);
            m.put("meaningEn", g.meaningEn);
            m.put("structure", g.structure);
            m.put("jlptLevel", g.jlptLevel);
            m.put("cefrLevel", g.cefrLevel);
            m.put("hskLevel", g.hskLevel);
            m.put("languageId", g.languageId);
            m.put("exampleSentence", g.exampleSentence);
            m.put("exampleTranslation", g.exampleTranslation);
            m.put("note", g.note);
            return m;
        }).collect(Collectors.toList());

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/{id}")
    public Response getGrammarDetail(@PathParam("id") Long id) {
        Grammar g = Grammar.findById(id);
        if (g == null) return Response.status(404).entity(Map.of("success", false, "message", "Not found")).build();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", g.id);
        data.put("languageId", g.languageId);
        data.put("pattern", g.pattern);
        data.put("meaningVi", g.meaningVi);
        data.put("meaningEn", g.meaningEn);
        data.put("structure", g.structure);
        data.put("jlptLevel", g.jlptLevel);
        data.put("cefrLevel", g.cefrLevel);
        data.put("hskLevel", g.hskLevel);
        data.put("exampleSentence", g.exampleSentence);
        data.put("exampleTranslation", g.exampleTranslation);
        data.put("note", g.note);
        data.put("explanationVi", g.explanationVi);
        data.put("explanationEn", g.explanationEn);
        data.put("formation", g.formation);
        data.put("usageContext", g.usageContext);
        data.put("commonMistakes", g.commonMistakes);
        data.put("relatedPatterns", g.relatedPatterns);
        data.put("difficultyScore", g.difficultyScore);
        data.put("audioUrl", g.audioUrl);

        List<GrammarExample> examples = GrammarExample.findByGrammar(id);
        data.put("examples", examples.stream().map(e -> {
            Map<String, Object> em = new LinkedHashMap<>();
            em.put("id", e.id);
            em.put("sentence", e.sentence);
            em.put("reading", e.reading);
            em.put("romaji", e.romaji);
            em.put("translationVi", e.translationVi);
            em.put("translationEn", e.translationEn);
            em.put("note", e.note);
            em.put("audioUrl", e.audioUrl);
            return em;
        }).collect(Collectors.toList()));

        List<GrammarExercise> exercises = GrammarExercise.findByGrammar(id);
        data.put("exercises", exercises.stream().map(e -> {
            Map<String, Object> em = new LinkedHashMap<>();
            em.put("id", e.id);
            em.put("type", e.type);
            em.put("questionJson", e.questionJson);
            em.put("answerJson", e.answerJson);
            em.put("explanation", e.explanation);
            em.put("difficulty", e.difficulty);
            return em;
        }).collect(Collectors.toList()));

        return Response.ok(Map.of("success", true, "data", data)).build();
    }
}
