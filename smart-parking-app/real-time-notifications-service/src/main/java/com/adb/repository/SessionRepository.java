package com.adb.repository;

import com.adb.model.Session;
import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
@AllArgsConstructor
public class SessionRepository {

    private final RedisTemplate<String,Object> redisTemplate;
    public void save(Session session){
        System.out.println("i' saving a session"+session.toString());
        redisTemplate.opsForHash().put("sessions" , session.getId().toString(), session);
    }

    public Session findById(Long id) {
        try {
            Object sessionObject = redisTemplate.opsForHash().get("sessions", id.toString());
            if (sessionObject != null) {
                return (Session) sessionObject;
            } else {
                // Session not found in Redis
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    public List<Session> findAll() {
        List<Session> sessions = new ArrayList<>();
        try {
            Map<Object, Object> sessionMap = redisTemplate.opsForHash().entries("sessions");
            for (Map.Entry<Object, Object> entry : sessionMap.entrySet()) {
                sessions.add((Session) entry.getValue());
            }
        } catch (Exception e) {
            // Handle exception if needed
        }
        return sessions;
    }
}
