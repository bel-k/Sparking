package com.adb.repository;

import com.adb.model.Parking;
import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Repository
@AllArgsConstructor
public class ParkingRepository  {
    private final RedisTemplate<String,Object> redisTemplate;
    public void save(Parking parking) {
        redisTemplate.opsForHash().put("parkings" , parking.getId().toString(), parking);
    }
    public Parking findById(Long id) {
        try {
            Object sessionObject = redisTemplate.opsForHash().get("parkings", id.toString());
            if (sessionObject != null) {
                return (Parking) sessionObject;
            } else {
                // Session not found in Redis
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    public List<Parking> findAll() {
        try {
            Map<Object, Object> sessionMap = redisTemplate.opsForHash().entries("parkings");
            return sessionMap.values().stream()
                    .map(sessionObject -> (Parking) sessionObject)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            // Handle the exception, e.g., log it
            e.printStackTrace();
            return null;
        }
    }
}
