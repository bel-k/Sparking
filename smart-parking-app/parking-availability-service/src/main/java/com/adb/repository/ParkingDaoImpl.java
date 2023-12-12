package com.adb.repository;

import com.adb.model.Parking;
import com.adb.model.Spot;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
public class ParkingDaoImpl implements ParkingDao {
    @Autowired
    private RedisTemplate  redisTemplate;
    private static final String PARKING_COUNTER_KEY = "parking_counter";
    public Long generateUniqueId() {
        return redisTemplate.opsForValue().increment(PARKING_COUNTER_KEY, 1);
    }
    private static final String KEYPARKING = "PARKING";
    @Override
    public boolean saveParking(Parking parking) {
        Long id = generateUniqueId();
        parking.setId(id);

        try {
            redisTemplate.opsForHash().put(KEYPARKING , parking.getId().toString(), parking);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Parking> fetchAllParking() {

        List<Parking> parkingList;
        parkingList = redisTemplate.opsForHash().values(KEYPARKING);
        return  parkingList;
    }

    @Override
    public Parking fetchParkingById(Long id) {
        Parking parking;
        parking = (Parking) redisTemplate.opsForHash().get(KEYPARKING,id.toString());
        return parking;
    }

    @Override
    public boolean deleteParking(Long id) {

        if (redisTemplate.opsForHash().hasKey(KEYPARKING, id.toString())) {
            redisTemplate.opsForHash().delete(KEYPARKING, id.toString());
            return true;
        } else {
            throw new IllegalArgumentException("Parking with id " + id + " does not exist");
        }
    }

    @Override
    public boolean updateParking(Long id, Parking parking) {

            if (redisTemplate.opsForHash().hasKey(KEYPARKING, id.toString())) {
                parking.setId(id);
                redisTemplate.opsForHash().put(KEYPARKING, id.toString(), parking);
                return true;
            }else{
              throw new IllegalArgumentException("Parking with id " + id + " does not exist");
        }
    }

    @Override
    public boolean patchParking(Long id, Map<String, Object> updates) {
        if (redisTemplate.opsForHash().hasKey(KEYPARKING, id.toString())) {
            Parking parking = (Parking) redisTemplate.opsForHash().get(KEYPARKING, id.toString());
            // Apply updates to the existing spot
            for (Map.Entry<String, Object> entry : updates.entrySet()) {
                String field = entry.getKey();
                Object value = entry.getValue();
                if (parking != null) {
                    switch (field) {
                        case "name":
                            parking.setName((String) value);
                            break;
                        case "description":
                            parking.setDescription((String) value);
                            break;
                        case "availabilityStatus":
                            parking.setAvailabilityStatus((Boolean) value);
                            break;
                    }
                }
            }
            // Save the updated spot back to Redis
            redisTemplate.opsForHash().put(KEYPARKING, id.toString(), parking);
            return true;
        } else {
            throw new IllegalArgumentException(" PARKING with id " + id + " does not exist");
        }
    }
}
