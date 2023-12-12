package com.adb.repository;

import com.adb.model.Notification;
import com.adb.model.SessionNotification;
import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
@AllArgsConstructor
public class SessionNotificationRepository  {
    private final RedisTemplate<String,Object> redisTemplate;
    public void save(SessionNotification sessionNotification){
        redisTemplate.opsForHash().put("sessionnotifications" , sessionNotification.getId().toString(), sessionNotification);
    }

    public List<SessionNotification> findBySessionId(Long sessionId) {
        Map<Object, Object> sessionNotificationsMap = redisTemplate.opsForHash().entries("sessionnotifications");

        return sessionNotificationsMap.values().stream()
                .map(sessionNotification -> (SessionNotification) sessionNotification)
                .filter(sessionNotification -> sessionNotification.getSession().getId().equals(sessionId))
                .collect(Collectors.toList());
    }

    public List<Notification> findNotificationsBySessionId(Long sessionId) {
        List<SessionNotification> sessionNotifications = findBySessionId(sessionId);
        return sessionNotifications.stream()
                .map(SessionNotification::getNotification)
                .collect(Collectors.toList());
    }

    public SessionNotification findBySessionNotificationId(long sessionNotificationId) {
        Map<Object, Object> sessionNotificationsMap = redisTemplate.opsForHash().entries("sessionnotifications");

        Optional<SessionNotification> foundNotification = sessionNotificationsMap.values().stream()
                .map(sessionNotification -> (SessionNotification) sessionNotification)
                .filter(sessionNotification -> sessionNotification.getId().equals(sessionNotificationId))
                .findFirst();

        return foundNotification.orElse(null); // Return null if not found, or handle it appropriately
    }

}
