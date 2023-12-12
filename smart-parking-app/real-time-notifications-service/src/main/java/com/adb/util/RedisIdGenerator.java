package com.adb.util;

import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class RedisIdGenerator {

    private static final String NOTIFICATION_ID_KEY = "notification:id";
    private static final String SESSIONNOTIFICATION_ID_KEY = "sessionnotification:id";

    private final RedisTemplate<String, String> redisTemplate;

    public Long generateNUniqueId() {
        return redisTemplate.opsForValue().increment(NOTIFICATION_ID_KEY);
    }
    public Long generateSNUniqueId() {
        return redisTemplate.opsForValue().increment(SESSIONNOTIFICATION_ID_KEY);
    }
}