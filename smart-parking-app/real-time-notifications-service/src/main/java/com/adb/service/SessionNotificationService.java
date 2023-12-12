package com.adb.service;

import com.adb.model.SessionNotification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SessionNotificationService {
    void save(SessionNotification sessionNotification);
    List<SessionNotification> findNotificationsBySessionId(Long sessionId);
}
