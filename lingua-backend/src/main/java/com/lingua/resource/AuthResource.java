package com.lingua.resource;

import com.lingua.entity.*;
import com.lingua.service.AuthService;
import com.lingua.dto.*;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.Map;

@Path("/api/auth")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AuthResource {

    @Inject
    AuthService authService;

    @POST
    @Path("/register")
    @Transactional
    public Response register(Map<String, String> body) {
        String email = body.get("email");
        String password = body.get("password");
        String displayName = body.get("displayName");

        if (email == null || password == null || displayName == null) {
            return Response.status(400).entity(Map.of("success", false, "message", "Email, password and displayName are required")).build();
        }
        if (User.findByEmail(email) != null) {
            return Response.status(409).entity(Map.of("success", false, "message", "EMAIL_EXISTED")).build();
        }

        User user = authService.register(email, password, displayName);
        String token = authService.generateToken(user);
        return Response.ok(Map.of(
            "success", true,
            "data", Map.of("token", token, "user", mapUser(user)),
            "message", "Registration successful"
        )).build();
    }

    @POST
    @Path("/login")
    @Transactional
    public Response login(Map<String, String> body) {
        String email = body.get("email");
        String password = body.get("password");

        User user = authService.authenticate(email, password);
        if (user == null) {
            return Response.status(401).entity(Map.of("success", false, "message", "Invalid credentials")).build();
        }

        String token = authService.generateToken(user);
        return Response.ok(Map.of(
            "success", true,
            "data", Map.of("token", token, "user", mapUser(user)),
            "message", "Login successful"
        )).build();
    }

    private Map<String, Object> mapUser(User u) {
        return Map.of(
            "id", u.id,
            "email", u.email,
            "displayName", u.displayName,
            "role", u.role.name(),
            "avatarUrl", u.avatarUrl != null ? u.avatarUrl : ""
        );
    }
}
