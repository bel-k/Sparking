package com.adb.repository;

import com.adb.model.Spot;

import java.util.List;
import java.util.Map;

public interface SpotDao {
    boolean saveSpot(Spot spot);
    List<Spot> fetchAllSpots();
    Spot fetchSpotById(Long id);

    boolean deleteSpot(Long id);

    boolean updateSpot(Long id, Spot spot);
    List<Spot> findByParkingId(Long parkingId);
     boolean patchSpot(Long id, Map<String, Object> updates) ;

}
