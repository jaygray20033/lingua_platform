package com.lingua.resource;

import com.lingua.entity.User;
import jakarta.annotation.security.PermitAll;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

@Path("/api/health")
@Produces(MediaType.APPLICATION_JSON)
public class HealthResource {

    @GET
    @PermitAll
    public Response health() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("status", "UP");
        data.put("version", "1.0.0");
        data.put("time", LocalDateTime.now().toString());

        try {
            long users = User.count();
            data.put("db", "UP");
            data.put("userCount", users);
        } catch (Exception e) {
            data.put("db", "DOWN");
            data.put("dbError", e.getMessage());
            return Response.status(503).entity(data).build();
        }
        return Response.ok(data).build();
    }
}
