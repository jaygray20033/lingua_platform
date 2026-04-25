package com.lingua.resource;

import com.lingua.entity.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.stream.Collectors;

@Path("/api")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class VocabularyResource {

    @GET
    @Path("/words/search")
    public Response searchWords(
        @QueryParam("q") String query,
        @QueryParam("lang") String lang,
        @QueryParam("level") String level,
        @QueryParam("page") @DefaultValue("1") int page,
        @QueryParam("limit") @DefaultValue("50") int limit) {

        List<Word> words;
        if (query != null && !query.isEmpty()) {
            words = Word.search(query);
        } else if (lang != null && level != null) {
            Language language = Language.findByCode(lang);
            if (language != null) {
                words = Word.findByLanguageAndLevel(language.id, level);
            } else {
                words = new ArrayList<>();
            }
        } else if (lang != null) {
            Language language = Language.findByCode(lang);
            if (language != null) {
                words = Word.list("languageId = ?1 order by frequencyRank", language.id);
            } else {
                words = new ArrayList<>();
            }
        } else {
            words = Word.listAll();
        }

        int start = (page - 1) * limit;
        int end = Math.min(start + limit, words.size());
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

            // Get meanings
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

        return Response.ok(Map.of(
            "success", true,
            "data", data,
            "pagination", Map.of("page", page, "limit", limit, "total", words.size())
        )).build();
    }

    @GET
    @Path("/words/{id}")
    public Response getWord(@PathParam("id") Long id) {
        Word word = Word.findById(id);
        if (word == null) return Response.status(404).build();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", word.id);
        data.put("text", word.text);
        data.put("reading", word.reading);
        data.put("romaji", word.romaji);
        data.put("pos", word.pos);
        data.put("jlptLevel", word.jlptLevel);
        data.put("cefrLevel", word.cefrLevel);
        data.put("hskLevel", word.hskLevel);

        List<WordMeaning> meanings = WordMeaning.findByWord(id);
        data.put("meanings", meanings.stream().map(wm -> Map.of(
            "meaning", wm.meaning != null ? wm.meaning : "",
            "exampleSentence", wm.exampleSentence != null ? wm.exampleSentence : "",
            "exampleTranslation", wm.exampleTranslation != null ? wm.exampleTranslation : ""
        )).collect(Collectors.toList()));

        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/characters")
    public Response listCharacters(
        @QueryParam("level") String level,
        @QueryParam("page") @DefaultValue("1") int page,
        @QueryParam("limit") @DefaultValue("50") int limit) {

        List<CharacterEntity> chars;
        if (level != null) chars = CharacterEntity.findByLevel(level);
        else chars = CharacterEntity.listAll();

        int start = (page - 1) * limit;
        int end = Math.min(start + limit, chars.size());
        List<CharacterEntity> paged = start < chars.size() ? chars.subList(start, end) : new ArrayList<>();

        List<Map<String, Object>> data = paged.stream().map(c -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.id);
            m.put("character", c.characterText);
            m.put("strokeCount", c.strokeCount);
            m.put("jlptLevel", c.jlptLevel);
            m.put("meaningVi", c.meaningVi);
            m.put("meaningEn", c.meaningEn);
            m.put("onReading", c.onReading);
            m.put("kunReading", c.kunReading);
            m.put("hanViet", c.hanViet);
            m.put("mnemonic", c.mnemonicText);
            return m;
        }).collect(Collectors.toList());

        return Response.ok(Map.of("success", true, "data", data, "pagination", Map.of("page", page, "total", chars.size()))).build();
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
        return Response.ok(Map.of("success", true, "data", data)).build();
    }

    @GET
    @Path("/grammars")
    public Response listGrammars(
        @QueryParam("lang") String lang,
        @QueryParam("level") String level) {

        List<Grammar> grammars;
        if (lang != null && level != null) {
            Language language = Language.findByCode(lang);
            if (language != null) grammars = Grammar.findByLanguageAndLevel(language.id, level);
            else grammars = new ArrayList<>();
        } else {
            grammars = Grammar.listAll();
        }

        List<Map<String, Object>> data = grammars.stream().map(g -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", g.id);
            m.put("pattern", g.pattern);
            m.put("meaningVi", g.meaningVi);
            m.put("meaningEn", g.meaningEn);
            m.put("structure", g.structure);
            m.put("jlptLevel", g.jlptLevel);
            m.put("exampleSentence", g.exampleSentence);
            m.put("exampleTranslation", g.exampleTranslation);
            m.put("note", g.note);
            return m;
        }).collect(Collectors.toList());

        return Response.ok(Map.of("success", true, "data", data)).build();
    }
}
