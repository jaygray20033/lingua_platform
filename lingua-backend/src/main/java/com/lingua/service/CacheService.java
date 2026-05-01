package com.lingua.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.quarkus.redis.datasource.RedisDataSource;
import io.quarkus.redis.datasource.value.ValueCommands;
import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.jboss.logging.Logger;

import java.time.Duration;
import java.time.Instant;
import java.util.function.Supplier;

@ApplicationScoped
public class CacheService {
    private static final Logger LOG = Logger.getLogger(CacheService.class);
    private static final ObjectMapper MAPPER = new ObjectMapper();

    public static final String PREFIX = "lingua:";

    public static final Duration DEFAULT_TTL = Duration.ofMinutes(30);

    private static final Duration RECONNECT_BACKOFF = Duration.ofSeconds(15);

    @Inject
    RedisDataSource redis;

    private volatile ValueCommands<String, String> commands;
    private volatile boolean enabled = true;
    private volatile Instant nextRetryAt = Instant.EPOCH;

    @PostConstruct
    void init() {
        tryConnect();
    }

    private synchronized boolean tryConnect() {
        if (commands != null && enabled) return true;
        if (Instant.now().isBefore(nextRetryAt)) return false;
        try {
            commands = redis.value(String.class);
            redis.key().exists(PREFIX + "_probe");
            enabled = true;
            LOG.info("Redis connection established - caching enabled.");
            return true;
        } catch (Exception e) {
            commands = null;
            enabled = false;
            nextRetryAt = Instant.now().plus(RECONNECT_BACKOFF);
            LOG.warnf("Redis not reachable - caching disabled until %s (%s)", nextRetryAt, e.getMessage());
            return false;
        }
    }

    public <T> T getOrCompute(String key, Duration ttl, TypeReference<T> type, Supplier<T> supplier) {
        String fullKey = PREFIX + key;
        if (tryConnect()) {
            try {
                String raw = commands.get(fullKey);
                if (raw != null) {
                    return MAPPER.readValue(raw, type);
                }
            } catch (Exception e) {
                LOG.debugf("Cache read miss for key=%s (%s)", key, e.getMessage());
                enabled = false;
                nextRetryAt = Instant.now().plus(RECONNECT_BACKOFF);
            }
        }

        T value = supplier.get();
        if (tryConnect() && value != null) {
            try {
                String json = MAPPER.writeValueAsString(value);
                Duration effective = ttl != null ? ttl : DEFAULT_TTL;
                commands.setex(fullKey, effective.getSeconds(), json);
            } catch (Exception e) {
                LOG.debugf("Cache write failed for key=%s (%s)", key, e.getMessage());
                enabled = false;
                nextRetryAt = Instant.now().plus(RECONNECT_BACKOFF);
            }
        }
        return value;
    }

    public void invalidate(String key) {
        if (!tryConnect()) return;
        try {
            redis.key().del(PREFIX + key);
        } catch (Exception e) {
            LOG.debugf("Cache invalidate failed for key=%s (%s)", key, e.getMessage());
            enabled = false;
            nextRetryAt = Instant.now().plus(RECONNECT_BACKOFF);
        }
    }

    public void invalidatePrefix(String prefix) {
        if (!tryConnect()) return;
        try {
            var keys = redis.key().keys(PREFIX + prefix + "*");
            if (keys != null && !keys.isEmpty()) {
                redis.key().del(keys.toArray(new String[0]));
            }
        } catch (Exception e) {
            LOG.debugf("Cache prefix invalidate failed for prefix=%s (%s)", prefix, e.getMessage());
            enabled = false;
            nextRetryAt = Instant.now().plus(RECONNECT_BACKOFF);
        }
    }

    public boolean isEnabled() { return tryConnect(); }
}
