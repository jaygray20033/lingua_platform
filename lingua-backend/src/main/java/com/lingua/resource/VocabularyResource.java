package com.lingua.resource;

import com.fasterxml.jackson.core.type.TypeReference;
import com.lingua.entity.*;
import com.lingua.service.CacheService;
import jakarta.annotation.security.PermitAll;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
@PermitAll
public class VocabularyResource {

    @Inject CacheService cache;

    @GET
    @Path("/words/search")
    public Response searchWords(
        @QueryParam("q") String query,
        @QueryParam("lang") String lang,
        @QueryParam("level") String level,
        @QueryParam("page") @DefaultValue("1") int page,
        @QueryParam("limit") @DefaultValue("50") int limit) {

        final int pageF = page;
        final int limitF = limit;
        String cacheKey = "vocab:search:" + String.valueOf(query) + ":" + String.valueOf(lang) + ":"
                + String.valueOf(level) + ":" + pageF + ":" + limitF;

        Map<String, Object> response = cache.getOrCompute(
            cacheKey,
            Duration.ofMinutes(10),
            new TypeReference<Map<String, Object>>() {},
            () -> {
                List<Word> words;
                if (query != null && !query.isEmpty()) {
                    words = Word.search(query);
                } else if (lang != null && level != null) {
                    Language language = Language.findByCode(lang);
                    words = (language != null) ? Word.findByLanguageAndLevel(language.id, level) : new ArrayList<>();
                } else if (lang != null) {
                    Language language = Language.findByCode(lang);
                    words = (language != null) ? Word.list("languageId = ?1 order by frequencyRank", language.id) : new ArrayList<>();
                } else {
                    words = Word.listAll();
                }

                int start = (pageF - 1) * limitF;
                int end = Math.min(start + limitF, words.size());
                List<Word> pagedWords = start < words.size() ? words.subList(start, end) : new ArrayList<>();

                List<Map<String, Object>> data = pagedWords.stream().map(w -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", w.id);
                    m.put("text", w.text);
                    m.put("reading", w.reading);
                    m.put("romaji", w.romaji);
                    m.put("pos", w.pos);
                    m.put("jlptLevel", w.jlptLevel);
                    m.put("cefrLevel", w.cefrLevel);
                    m.put("hskLevel", w.hskLevel);
                    m.put("frequencyRank", w.frequencyRank);

                    m.put("audioUrl", w.audioUrl);
                    List<WordMeaning> meanings = WordMeaning.findByWord(w.id);
                    if (!meanings.isEmpty()) {
                        m.put("meanings", meanings.stream().map(wm -> {
                            Map<String, Object> mm = new LinkedHashMap<>();
                            mm.put("meaning", wm.meaning);
                            mm.put("exampleSentence", wm.exampleSentence);
                            mm.put("exampleTranslation", wm.exampleTranslation);
                            return mm;
                        }).collect(Collectors.toList()));
                    }
                    return m;
                }).collect(Collectors.toList());

                Map<String, Object> out = new LinkedHashMap<>();
                out.put("success", true);
                out.put("data", data);
                out.put("pagination", Map.of("page", pageF, "limit", limitF, "total", words.size()));
                return out;
            }
        );
        return Response.ok(response).build();
    }

    @GET
    @Path("/words/{id}")
    public Response getWord(@PathParam("id") Long id) {
        String key = "word:" + id;
        Map<String, Object> data = cache.getOrCompute(
            key,
            Duration.ofHours(1),
            new TypeReference<Map<String, Object>>() {},
            () -> {
                Word word = Word.findById(id);
                if (word == null) return null;
                Map<String, Object> d = new LinkedHashMap<>();
                d.put("id", word.id);
                d.put("text", word.text);
                d.put("reading", word.reading);
                d.put("romaji", word.romaji);
                d.put("pos", word.pos);
                d.put("jlptLevel", word.jlptLevel);
                d.put("cefrLevel", word.cefrLevel);
                d.put("hskLevel", word.hskLevel);

                d.put("audioUrl", word.audioUrl);

                List<WordMeaning> meanings = WordMeaning.findByWord(id);
                d.put("meanings", meanings.stream().map(wm -> Map.of(
                    "meaning", wm.meaning != null ? wm.meaning : "",
                    "exampleSentence", wm.exampleSentence != null ? wm.exampleSentence : "",
                    "exampleTranslation", wm.exampleTranslation != null ? wm.exampleTranslation : ""
                )).collect(Collectors.toList()));

                List<ExampleSentence> examples = ExampleSentence.findTopForWord(id, 3);
                d.put("examples", examples.stream().map(es -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", es.id);
                    m.put("sentence", es.sentence);
                    m.put("reading", es.reading);
                    m.put("translationVi", es.translationVi);
                    m.put("translationEn", es.translationEn);
                    m.put("audioUrl", es.audioUrl);
                    m.put("difficulty", es.difficulty);
                    return m;
                }).collect(Collectors.toList()));
                return d;
            }
        );
        if (data == null) return Response.status(404).build();
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/characters")
    public Response listCharacters(
        @QueryParam("level") String level,
        @QueryParam("lang") String lang,
        @QueryParam("q") String query,
        @QueryParam("page") @DefaultValue("1") int page,
        @QueryParam("limit") @DefaultValue("100") int limit) {

        final int pageF = page;
        final int limitF = limit;
        String cacheKey = "chars:" + String.valueOf(lang) + ":" + String.valueOf(level) + ":"
                + String.valueOf(query) + ":" + pageF + ":" + limitF;

        Map<String, Object> response = cache.getOrCompute(
            cacheKey,
            Duration.ofMinutes(15),
            new TypeReference<Map<String, Object>>() {},
            () -> {
                StringBuilder qb = new StringBuilder("1=1");
                List<Object> params = new ArrayList<>();
                int idx = 1;
                if (lang != null) {
                    Language language = Language.findByCode(lang);
                    if (language != null) {
                        qb.append(" and languageId = ?" + (idx++));
                        params.add(language.id);
                    }
                }
                if (level != null) {
                    qb.append(" and (jlptLevel = ?" + idx + " or hskLevel = ?" + idx + ")");
                    params.add(level);
                    idx++;
                }
                if (query != null && !query.isEmpty()) {
                    qb.append(" and (characterText like ?" + idx + " or meaningVi like ?" + idx + " or hanViet like ?" + idx + ")");
                    params.add("%" + query + "%");
                    idx++;
                }
                List<CharacterEntity> chars = CharacterEntity.list(
                    qb.toString() + " order by strokeCount, characterText", params.toArray());

                int start = (pageF - 1) * limitF;
                int end = Math.min(start + limitF, chars.size());
                List<CharacterEntity> paged = start < chars.size() ? chars.subList(start, end) : new ArrayList<>();

                List<Map<String, Object>> data = paged.stream().map(c -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", c.id);
                    m.put("characterText", c.characterText);
                    m.put("character", c.characterText);
                    m.put("strokeCount", c.strokeCount);
                    m.put("jlptLevel", c.jlptLevel);
                    m.put("hskLevel", c.hskLevel);
                    m.put("languageId", c.languageId);
                    m.put("meaningVi", c.meaningVi);
                    m.put("meaningEn", c.meaningEn);
                    m.put("onReading", c.onReading);
                    m.put("kunReading", c.kunReading);
                    m.put("hanViet", c.hanViet);
                    m.put("mnemonic", c.mnemonicText);

                    m.put("strokeOrderJson", c.strokeOrderJson);
                    return m;
                }).collect(Collectors.toList());

                Map<String, Object> out = new LinkedHashMap<>();
                out.put("success", true);
                out.put("data", data);
                out.put("pagination", Map.of("page", pageF, "total", chars.size()));
                return out;
            }
        );
        return Response.ok(response).build();
    }

    @GET
    @Path("/characters/{charText}")
    public Response getCharacter(@PathParam("charText") String charText) {
        CharacterEntity c = CharacterEntity.findByChar(charText);
        if (c == null) return Response.status(404).build();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", c.id);
        data.put("character", c.characterText);
        data.put("strokeCount", c.strokeCount);
        data.put("jlptLevel", c.jlptLevel);
        data.put("meaningVi", c.meaningVi);
        data.put("meaningEn", c.meaningEn);
        data.put("onReading", c.onReading);
        data.put("kunReading", c.kunReading);
        data.put("hanViet", c.hanViet);
        data.put("mnemonic", c.mnemonicText);

        data.put("strokeOrderJson", c.strokeOrderJson);
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    // NOTE: Endpoint /api/grammars (LIST + DETAIL) moved to GrammarResource
    // to fix BUG-06: routing conflict caused 404 on /api/grammars
}
