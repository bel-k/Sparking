package com.adb.repository;

import com.adb.model.Notification;
import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;


@Repository
@AllArgsConstructor
public class NotificationRepository  {
    private final RedisTemplate<String,Object> redisTemplate;
        public void save(Notification notification) {
            redisTemplate.opsForHash().put("notifications" , notification.getId().toString(), notification);
        }
}
