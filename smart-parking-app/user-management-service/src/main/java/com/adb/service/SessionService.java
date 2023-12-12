package com.adb.service;

import com.adb.model.Account;
import com.adb.model.Session;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public interface SessionService {
     Session createSession(Account account, String token, Date startTime, Date endTime,boolean isAuthenticated);
     Optional<Session> getSessionByToken(String token);
    void deleteSessionByToken(String token);
    List<Session> getSessionsByAccountId(Long accountId);
}
