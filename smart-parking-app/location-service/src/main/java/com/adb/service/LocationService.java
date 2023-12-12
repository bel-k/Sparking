package com.adb.service;

import com.adb.helper.RequestResponseHelper;
import com.adb.model.Parking;
import com.adb.repository.LocationRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
@Primary
public class LocationService {
    @Autowired
    private LocationRepository locationRepository;

    public Map<String,Object> getNearbyParkingsByLocation(String latStr, String lonStr, String diametreStr){
        if (latStr == null || lonStr == null || diametreStr == null) {
            return RequestResponseHelper.error(null,400,"Not authorized! Lat or Lon or Diametre is missing");
        }
        else{
            double lat = Double.parseDouble(latStr);
            double lon = Double.parseDouble(lonStr);
            double diametre = Double.parseDouble(diametreStr);
            System.out.println(lat+" "+lon+" "+diametreStr);
            List<Parking> nearbyParkings = locationRepository.findNearbyParkings(lat, lon, diametre);
            for (Parking parking : nearbyParkings) {
                System.out.println(parking.toString());
            }
            if(nearbyParkings.isEmpty()){
                return RequestResponseHelper.error(null,401,"No parkings found in this diametre");
            }
            else{
                Map<String, Object> mapParkings = new HashMap<String,Object>();
                int i=0;
                for(Parking P : nearbyParkings) mapParkings.put(""+(i++)+"",P.mapParking());
                return RequestResponseHelper.success(mapParkings,200,"List of parkings got successfully");
            }
        }
    }
}