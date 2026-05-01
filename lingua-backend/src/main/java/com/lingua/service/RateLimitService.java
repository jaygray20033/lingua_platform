package com.lingua.service;

import io.quarkus.redis.datasource.RedisDataSource;
import io.quarkus.redis.datasource.value.ValueCommands;
import jakarta.annotation.PostConstruct;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.jboss.logging.Logger;

import java.time.Duration;
import java.util.concurrent.ConcurrentHashMap;

@ApplicationScoped
public class RateLimitService {
    private static final Logger LOG = Logger.getLogger(RateLimitService.class);
    private static final String PREFIX = "lingua:rl:";

    @Inject
    RedisDataSource redis;

    private ValueCommands<String, String> commands;
    private boolean redisEnabled = true;

    private final ConcurrentHashMap<String, long[]> memBuckets = new ConcurrentHashMap<>();

    @PostConstruct
    void init() {
        try {
            commands = redis.value(String.class);
        } catch (Exception e) {
            LOG.warn("RateLimitService: Redis unavailable, using in-memory buckets: " + e.getMessage());
            redisEnabled = false;
        }
    }

    public boolean tryAcquire(String bucket, int max, Duration window) {
        if (bucket == null || bucket.isBlank()) return true;
        int count = increment(bucket, window);
        return count <= max;
    }

    public int currentCount(String bucket) {
        if (redisEnabled && commands != null) {
            try {
                String v = commands.get(PREFIX + bucket);
                return v == null ? 0 : Integer.parseInt(v);
            } catch (Exception ignore) {}
        }
        long[] b = memBuckets.get(bucket);
        if (b == null || b[1] < System.currentTimeMillis()) return 0;
        return (int) b[0];
    }

    private int increment(String bucket, Duration window) {
        if (redisEnabled && commands != null) {
            try {
                String key = PREFIX + bucket;
                long newVal = redis.value(Long.class).incr(key);
                if (newVal == 1L) {
                    redis.key().expire(key, window.getSeconds());
                }
                return (int) newVal;
            } catch (Exception e) {
                LOG.debugf("Redis rate-limit incr failed (%s), falling back to memory", e.getMessage());
            }
        }
        long now = System.currentTimeMillis();
        long[] next = memBuckets.compute(bucket, (k, v) -> {
            if (v == null || v[1] < now) {
                return new long[] { 1L, now + window.toMillis() };
            }
            v[0] += 1L;
            return v;
        });
        return (int) next[0];
    }
}
