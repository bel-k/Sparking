package com.adb.repository;


import com.adb.model.Spot;
import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class SpotDaoImpl implements SpotDao {
    @Autowired
    private RedisTemplate redisTemplate;
    private static final String SPOT_COUNTER_KEY = "spot_counter";
    public Long generateUniqueId() {
        return redisTemplate.opsForValue().increment(SPOT_COUNTER_KEY, 1);
    }

    private static final String KEY = "SPOT";
    @Override
    public boolean saveSpot(Spot spot) {
        Long id = generateUniqueId();
        spot.setSpotId(id);

        try {
            redisTemplate.opsForHash().put(KEY, spot.getSpotId().toString(), spot);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    @Override
    public List<Spot> fetchAllSpots() {
        List<Spot> spotList;
        spotList = redisTemplate.opsForHash().values(KEY);
        return  spotList;
    }

    @Override
    public Spot fetchSpotById(Long id) {
        Spot spot;
        spot = (Spot) redisTemplate.opsForHash().get(KEY,id.toString());
        return spot;
    }

    @Override
    public boolean deleteSpot(Long id) {

            if (redisTemplate.opsForHash().hasKey(KEY, id.toString())) {
                redisTemplate.opsForHash().delete(KEY, id.toString());
                return true;
            } else {
                throw new IllegalArgumentException("spot with id " + id + " does not exist");
            }
    }

    @Override
    public boolean updateSpot(Long id, Spot spot) {

            if (redisTemplate.opsForHash().hasKey(KEY, id.toString())) {
                spot.setSpotId(id);
                redisTemplate.opsForHash().put(KEY, id.toString(), spot);
                return true;
            }else{
                throw new IllegalArgumentException("spot with id " + id + " does not exist");
            }

    }

    @Override
    public List<Spot> findByParkingId(Long parkingId) {
       List <Spot> spots = fetchAllSpots();
        List <Spot> spotsInParking = new ArrayList<>();
        for (Spot sp : spots) {
             if(sp.getParking().getId().equals(parkingId)){
                 spotsInParking.add(sp);
             }
        }
        return spotsInParking;
    }
    @Override
    public boolean patchSpot(Long id, Map<String, Object> updates) {
        if (redisTemplate.opsForHash().hasKey(KEY, id.toString())) {
            Spot spot = (Spot) redisTemplate.opsForHash().get(KEY, id.toString());

            // Apply updates to the existing spot
            for (Map.Entry<String, Object> entry : updates.entrySet()) {
                String field = entry.getKey();
                Object value = entry.getValue();

                switch (field) {
                    case "number":
                        spot.setNumber((int) value);
                        break;
                    case "price":
                        spot.setPrice((float) value);
                        break;
                    case "availabilityStatus":
                        spot.setAvailabilityStatus((Boolean) value);
                        break;
                    case "vehicleType":
                        spot.setVehicleType((String) value);
                        break;

                    // Add more fields as needed

                    default:
                        throw new IllegalArgumentException("Invalid field name: " + field);
                }
            }

            // Save the updated spot back to Redis
            redisTemplate.opsForHash().put(KEY, id.toString(), spot);
            return true;
        } else {
            throw new IllegalArgumentException("Spot with id " + id + " does not exist");
        }
    }



}
