package com.adb.service;

import com.adb.helper.RequestResponseHelper;
import com.adb.model.Location;
import com.adb.model.Session;
import com.adb.repository.LocationRepository;
import com.adb.repository.SessionRepository;
import jakarta.transaction.Transactional;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
@Primary
public class SessionService {
    @Autowired
    private SessionRepository sessionRepository;
    @Autowired
    private LocationRepository locationRepository;

    public List<Session> findNearbySessions(String parkingLatStr, String parkingLonStr){
        double parkingLat = Double.parseDouble(parkingLatStr);
        double parkingLon = Double.parseDouble(parkingLonStr);
        List<Session> nearbySessions = sessionRepository.findNearbySessions(parkingLat, parkingLon, 8000); // On suppose 1000m
        return nearbySessions;
    }

    public Long saveSession(String idStr, String latStr, String lonStr){
        double lat = Double.parseDouble(latStr);
        double lon = Double.parseDouble(lonStr);
        Long id = Long.parseLong(idStr);
        Optional<Session> sessionOpt =  sessionRepository.findById(id);
        GeometryFactory geometryFactory = new GeometryFactory();
        Coordinate coordinate = new Coordinate(lon, lat);
        Point point = geometryFactory.createPoint(coordinate);

        if(sessionOpt.isEmpty()){
            Location sessionLocation = new Location();
            sessionLocation.setLocationGeometry(point);
            locationRepository.save(sessionLocation);
            Session session = new Session();
            session.setId(id);
            session.setLocation(sessionLocation);
            sessionRepository.save(session);
            return session.getId();
            //return RequestResponseHelper.success(session,200,"SessionLocation Saved successfully");
        }else{
            Session sessionExist  = sessionOpt.get();
            Location locationExist = sessionExist.getLocation();
            locationExist.setLocationGeometry(point);
            locationRepository.saveAndFlush(locationExist);
            sessionExist.setLocation(locationExist);
            sessionRepository.saveAndFlush(sessionExist);
            return sessionExist.getId();
            //return RequestResponseHelper.success(sessionExist,201,"SessionLocation Updated successfully");
        }

    }
}