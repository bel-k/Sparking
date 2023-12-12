package com.adb.controller;
import com.adb.model.Session;
import com.adb.service.LocationService;
import com.adb.service.SessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/location")
@RequiredArgsConstructor
public class LocationController {
    @Autowired
    private LocationService locationService;
    @Autowired
    private SessionService sessionService;
    @GetMapping("/{lat},{lon},{diametre}/GetNearbyParkings")
    public Map<String,Object> getNearbyParkings(@PathVariable String lat, @PathVariable String lon, @PathVariable String diametre){
        return(locationService.getNearbyParkingsByLocation(lat,lon,diametre));
    }

    @GetMapping("/{lat},{lon}/find-nearby-sessions")
    public List<Session> findNearbySessions(@PathVariable String lat, @PathVariable String lon){
        return(sessionService.findNearbySessions(lat,lon));
    }

    @PostMapping("/{id},{lat},{lon}/saveLocationSession")
    public Long saveSessionLocation(@PathVariable String id,@PathVariable String lat, @PathVariable String lon) {
        return(sessionService.saveSession(id,lat,lon));
    }


}