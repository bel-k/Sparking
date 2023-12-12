package com.adb.repository;

import com.adb.model.Parking;



import java.util.List;
import java.util.Map;

public interface ParkingDao {
    boolean saveParking(Parking parking);
    List<Parking> fetchAllParking();
    Parking fetchParkingById(Long id);

    boolean deleteParking(Long id);

    boolean updateParking(Long id, Parking parking);
    boolean patchParking(Long id, Map<String, Object> updates) ;

}
