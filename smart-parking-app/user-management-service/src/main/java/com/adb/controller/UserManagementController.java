package com.adb.controller;

import com.adb.dto.JwtAuthenticationResponse;
import com.adb.dto.SignInRequest;
import com.adb.dto.SignUpRequest;
import com.adb.exception.AccountException;
import com.adb.model.Session;
import com.adb.service.implementation.AuthenticationService;
import com.adb.service.implementation.PageEventProducer;
import com.adb.service.implementation.SessionServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-management")
@RequiredArgsConstructor
public class UserManagementController {

    private final AuthenticationService authenticationService;
    private final SessionServiceImpl sessionService;
    private final PageEventProducer pageEventProducer;
    @PostMapping("/signup")
    public JwtAuthenticationResponse signup(@RequestBody SignUpRequest request) throws AccountException {
        return authenticationService.signup(request);
    }

    @PostMapping("/signin")
    public JwtAuthenticationResponse signin(@RequestBody SignInRequest request) {
        return authenticationService.signin(request);
    }
    @PostMapping("/logout")
    public ResponseEntity<String> logout(@RequestHeader("Authorization") String token) {
        Session session = sessionService.getSessionByToken(token.substring(7)).orElse(null);
        if (session != null) {
            session.setAuthenticated(false);
            sessionService.save(session);
            //pageEventProducer.sendUpdateSessionEvent(session);
            pageEventProducer.sendSessionEvent(session);
            return ResponseEntity.ok("Logout successful");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid session");
        }
    }
    @GetMapping("/get/{accountId}/sessions")
    public ResponseEntity<List<Session>> getSessions(@PathVariable Long accountId) {
        return ResponseEntity.ok(sessionService.getSessionsByAccountId(accountId));
    }

}
