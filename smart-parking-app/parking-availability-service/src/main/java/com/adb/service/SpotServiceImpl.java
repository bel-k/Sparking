package com.adb.service;

import com.adb.model.Spot;
import com.adb.repository.SpotDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service


public class SpotServiceImpl implements  SpotsService{
//    private static final String SPOT = "Spot";
//
//    private RedisTemplate<String, Object> redisTemplate;
//
//    private HashOperations<String, Long, ParkingSpot> hashOperations;
//
//    @Autowired
//    public SpotServiceImpl(RedisTemplate<String, Object> redisTemplate) {
//        this.redisTemplate = redisTemplate;
//    }
//
//    @PostConstruct
//    public void init() {
//        this.hashOperations = redisTemplate.opsForHash();
//    }
//
//    @Override
//    public ParkingSpot saveSpot(ParkingSpot spot) {
//        hashOperations.put(SPOT, Long.valueOf(spot.getSpotId()), spot);
//        return spot;
//    }
    @Autowired
    private SpotDao spotDao;

    @Override
    public boolean saveSpot(Spot spot) {
        return spotDao.saveSpot(spot);
    }

    @Override
    public List<Spot> fetchAllSpot() {
        return spotDao.fetchAllSpots();
    }

    @Override
    public Spot fetchSpotById(Long id) {
        return spotDao.fetchSpotById(id);
    }

    @Override
    public boolean deleteSpot(Long id) {
        return spotDao.deleteSpot(id);
    }

    @Override
    public boolean updateSpot(Long id, Spot Spot) {
        return spotDao.updateSpot(id,Spot);
    }

    @Override
    public List<Spot> getSpotsByParkingId(Long ParkingId) {
        return spotDao.findByParkingId(ParkingId);
    }

    @Override
    public boolean patchSpot(Long id, Map<String, Object> updates) {
        return spotDao.patchSpot(id,updates);
    }

}