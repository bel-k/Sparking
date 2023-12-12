package com.adb.service.implementation;

import com.adb.dto.JwtAuthenticationResponse;
import com.adb.dto.SignInRequest;
import com.adb.dto.SignUpRequest;
import com.adb.exception.AccountException;
import com.adb.model.Account;
import com.adb.model.Session;
import com.adb.model.User;
import com.adb.repository.AccountRepository;
import com.adb.repository.UserRepository;
import com.adb.service.AccountService;
import com.adb.service.SessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final AccountRepository accountRepository;
    private final UserRepository userRepo;
    private final AccountService accountService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final SessionService sessionService;
    private final IdGenerationService idGenerationService;
    @Value("${token.expirationms}")
    Long jwtExpirationMs;
    public JwtAuthenticationResponse signup(SignUpRequest request) throws AccountException {
        if (accountRepository.findByLogin(request.getEmail()).isPresent()) {
            throw new AccountException("User already registred");
        }
        var user = User
                .builder()
                .id(idGenerationService.generateNextId("session_sequence"))
                .firstName(request.getUser().getFirstName())
                .lastName(request.getUser().getLastName())
                .email(request.getUser().getEmail())
                .phoneNumber(request.getUser().getPhoneNumber())
                .disabled(request.getUser().isDisabled())
                .vehicleType(request.getUser().getVehicleType())
                .build();
        user = userRepo.save(user);
        var account = Account
                .builder()
                .id(idGenerationService.generateNextId("session_sequence"))
                .login(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .creationDate(new Date(System.currentTimeMillis()))
                .user(user)
                .build();

        account = accountService.save(account);
        var jwt = jwtService.generateToken(account);

        return JwtAuthenticationResponse.builder()
                .token(jwt).
                build();
    }


    public JwtAuthenticationResponse signin(SignInRequest request) {
//        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getLogin(), request.getPassword()));

        var account = accountRepository.findByLogin(request.getLogin())
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or password."));
        var jwt = jwtService.generateToken(account);
        Date startTime = new Date();
        Date endTime = new Date(System.currentTimeMillis() + jwtExpirationMs);
        Session session = sessionService.createSession(account, jwt, startTime, endTime,true);

        // Return JWT and session token in the response
        return JwtAuthenticationResponse.builder()
                .token(jwt)
                .sessionId(session.getId())
                .sessionToken(session.getToken())
                .build();
    }
    public boolean isValidSessionToken(String sessionToken) {
        try {
            // Extract the expiration time from the session token stored in the database
            Optional<Session> sessionOptional = sessionService.getSessionByToken(sessionToken);
            if (sessionOptional.isPresent()) {
                Date expirationTime = sessionOptional.get().getEndTime();
                // Check if the token has expired
                return !expirationTime.before(new Date());
            }
        } catch (Exception e) {
            // Handle any exceptions that might occur during validation
            // Log the error or return false based on your use case
            return false;
        }
        // If session not found or any other exception occurred, consider the token invalid
        return false;
    }

}
