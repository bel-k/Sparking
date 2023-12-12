package com.adb.service;

import com.adb.model.Parking;
import com.adb.repository.ParkingDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service

public class ParkingServiceImpl implements  ParkingService{
    @Autowired
    private ParkingDao parkingDao;
    @Override
    public boolean saveParking(Parking parking) {
        return parkingDao.saveParking(parking);
    }

    @Override
    public List<Parking> fetchAllParking() {
        return parkingDao.fetchAllParking();
    }

    @Override
    public Parking fetchParkingById(Long id) {
        return parkingDao.fetchParkingById(id);
    }

    @Override
    public boolean deleteParking(Long id) {
        return parkingDao.deleteParking(id);
    }

    @Override
    public boolean updateParking(Long id, Parking parking) {
        return parkingDao.updateParking(id,parking);

    }

    @Override
    public boolean patchParking(Long id, Map<String, Object> updates) {
        return parkingDao.patchParking(id,updates);
    }
}
