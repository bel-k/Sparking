package com.adb.service;

import com.adb.model.Session;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface SessionService {
    void save(Session session);
    List<Session> findNearbySessions(double parkingLatitude, double parkingLongitude);

    Session findById(Long Id);
}
