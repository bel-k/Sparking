package com.adb.service.implementation;

import com.adb.model.Account;
import com.adb.model.Session;
import com.adb.repository.SessionRepository;
import com.adb.service.SessionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SessionServiceImpl implements SessionService {
    private final SessionRepository sessionRepository;
    private final PageEventProducer pageEventProducer;

    private final IdGenerationService idGenerationService;
    public Session createSession(Session session) {
        Long id = idGenerationService.generateNextId("session_sequence");
        session.setId(id);
        System.out.println("hana hna");
        pageEventProducer.sendSessionEvent(session);
        System.out.println("hana ftha");
        return sessionRepository.save(session);
    }
    @Override
    public Session createSession(Account account, String token, Date startTime, Date endTime,boolean isAuthenticated) {
        Session session = new Session();
        session.setAccount(account);
        session.setToken(token);
        session.setStartTime(startTime);
        session.setEndTime(endTime);
        session.setAuthenticated(isAuthenticated);
        return createSession(session);
    }

    @Override
    public Optional<Session> getSessionByToken(String token) {
        return sessionRepository.findByToken(token);
    }

    @Override
    public void deleteSessionByToken(String token) {
        sessionRepository.deleteByToken(token);
    }

    @Override
    public List<Session> getSessionsByAccountId(Long accountId) {
        return sessionRepository.findByAccount_Id(accountId);
    }

    public void save(Session s){
        sessionRepository.save(s);
    }
}
