package com.adb.service;

import com.adb.model.Parking;

import java.util.List;

public interface ParkingService {
    void save(Parking parking);
    void saveFreeSpotForParking(Long parkingId);
    List<Parking> findAll();
}
