package com.lingua.filter;

import com.lingua.service.RateLimitService;
import io.vertx.core.http.HttpServerRequest;
import jakarta.inject.Inject;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.ext.Provider;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.jwt.JsonWebToken;
import org.jboss.logging.Logger;

import java.time.Duration;
import java.util.Map;
import java.util.Set;

@Provider
public class GlobalRateLimitFilter implements ContainerRequestFilter {

    private static final Logger LOG = Logger.getLogger(GlobalRateLimitFilter.class);

    private static final Set<String> SKIP_PREFIXES = Set.of(
        "/api/health",
        "/q/",
        "/openapi",
        "/swagger",
        "/static/",
        "/favicon.ico"
    );

    @Inject
    RateLimitService rateLimiter;

    @Inject
    JsonWebToken jwt;

    @ConfigProperty(name = "lingua.ratelimit.global.ip.max", defaultValue = "120")
    int ipMax;

    @ConfigProperty(name = "lingua.ratelimit.global.ip.window-seconds", defaultValue = "60")
    int ipWindowSec;

    @ConfigProperty(name = "lingua.ratelimit.global.user.max", defaultValue = "300")
    int userMax;

    @ConfigProperty(name = "lingua.ratelimit.global.user.window-seconds", defaultValue = "60")
    int userWindowSec;

    @ConfigProperty(name = "lingua.ratelimit.enabled", defaultValue = "true")
    boolean enabled;

    @Context
    jakarta.ws.rs.core.HttpHeaders headers;

    @Context
    HttpServerRequest vertxRequest;

    @Override
    public void filter(ContainerRequestContext ctx) {
        if (!enabled) return;

        String path = ctx.getUriInfo().getPath();
        if (path == null) return;

        String full = path.startsWith("/") ? path : "/" + path;

        if (!full.startsWith("/api/")) return;
        for (String skip : SKIP_PREFIXES) {
            if (full.startsWith(skip)) return;
        }

        if ("OPTIONS".equalsIgnoreCase(ctx.getMethod())) return;

        String ip = clientIp(ctx);
        if (ip != null && !ip.isBlank()) {
            if (!rateLimiter.tryAcquire("global:ip:" + ip, ipMax, Duration.ofSeconds(ipWindowSec))) {
                ctx.abortWith(too429(ipWindowSec, "Too many requests from your IP. Please slow down."));
                return;
            }
        }

        try {
            if (jwt != null && jwt.getRawToken() != null && jwt.getSubject() != null) {
                String userBucket = "global:user:" + jwt.getSubject();
                if (!rateLimiter.tryAcquire(userBucket, userMax, Duration.ofSeconds(userWindowSec))) {
                    ctx.abortWith(too429(userWindowSec, "Too many requests on this account."));
                    return;
                }
            }
        } catch (Exception ignored) {

        }
    }

    private static Response too429(int retryAfterSeconds, String msg) {
        return Response.status(429)
            .header("Retry-After", retryAfterSeconds)
            .header("X-RateLimit-Reason", "global")
            .entity(Map.of("success", false, "message", msg))
            .build();
    }

    private String clientIp(ContainerRequestContext ctx) {
        MultivaluedMap<String, String> h = ctx.getHeaders();
        String fwd = h.getFirst("X-Forwarded-For");
        if (fwd != null && !fwd.isBlank()) {
            int comma = fwd.indexOf(',');
            return (comma > 0 ? fwd.substring(0, comma) : fwd).trim();
        }
        String real = h.getFirst("X-Real-IP");
        if (real != null && !real.isBlank()) return real.trim();
        try {
            if (vertxRequest != null && vertxRequest.remoteAddress() != null) {
                return vertxRequest.remoteAddress().host();
            }
        } catch (Exception e) {
            LOG.debugf("Could not resolve remote address: %s", e.getMessage());
        }
        return null;
    }
}
