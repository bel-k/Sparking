package com.adb.service;

import com.adb.model.Spot;
import java.util.List;
import java.util.Map;

public interface SpotsService {

    boolean saveSpot (Spot spot);

  List <Spot> fetchAllSpot ();

    Spot fetchSpotById(Long id);

    boolean deleteSpot (Long id);

    boolean updateSpot(Long id, Spot Spot );
    List<Spot>  getSpotsByParkingId(Long ParkingId);
  boolean patchSpot(Long id, Map<String, Object> updates );

}
