package com.adb.service.impl;

import com.adb.model.Session;
import com.adb.repository.SessionRepository;
import com.adb.service.SessionService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class SessionServiceImpl implements SessionService {

    private final SessionRepository sessionRepository;
    @Override
    public void save(Session session) {
        sessionRepository.save(session);
    }

    @Override
    public List<Session> findNearbySessions(double parkingLatitude, double parkingLongitude) {
        //HERE I SHOULD USE kafka WITH ZINEB4S CODE
//        String url = POSTGIS_SERVICE_URL + "?latitude=" + parkingLatitude + "&longitude=" + parkingLongitude;
        /*ResponseEntity<List<Session>> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                null,
                new ParameterizedTypeReference<List<Session>>() {});
        return response.getBody();*/
        /*List<Session> sessions = new ArrayList<>();
        sessions.add(sessionRepository.findById(1L));
        sessions.add(sessionRepository.findById(3L));
        sessions.add(sessionRepository.findById(5L));*/
        return sessionRepository.findAll();
    }

    @Override
    public Session findById(Long Id) {
        return sessionRepository.findById(Id);
    }
}
