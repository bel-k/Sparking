package com.adb.service.impl;

import com.adb.model.SessionNotification;
import com.adb.repository.SessionNotificationRepository;
import com.adb.service.SessionNotificationService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class SessionNotificationServiceImpl implements SessionNotificationService {
    private final SessionNotificationRepository sessionNotificationRepository;
    @Override
    public void save(SessionNotification sessionNotification) {
        sessionNotificationRepository.save(sessionNotification);
    }

    @Override
    public List<SessionNotification> findNotificationsBySessionId(Long sessionId) {
        return sessionNotificationRepository.findBySessionId(sessionId);
    }

    public void markAsRead(long sessionNotificationId) {
        SessionNotification sessionNotification = sessionNotificationRepository.findBySessionNotificationId(sessionNotificationId);
        if(sessionNotification == null)
            System.out.println("wa nuuuuullll");

        //System.out.println("here i have "+sessionNotification.isRead());
        sessionNotification.setRead(true);
        sessionNotificationRepository.save(sessionNotification);
    }
}
