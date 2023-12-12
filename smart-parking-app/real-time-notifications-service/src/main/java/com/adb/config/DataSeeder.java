package com.adb.config;

import com.adb.model.Parking;
import com.adb.service.impl.ParkingServiceImpl;
import com.adb.service.impl.SessionServiceImpl;
import lombok.AllArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@AllArgsConstructor
public class DataSeeder implements CommandLineRunner {
    private final SessionServiceImpl sessionService;
    private final ParkingServiceImpl parkingService;
    @Override
    public void run(String... args) throws Exception {

        parkingService.save(new Parking(1L, "Parking 1", "Description of Parking 1", 34.0522, -118.2437, 10));
        parkingService.save(new Parking(2L, "Parking 2", "Description of Parking 2", 34.0522, -118.2437, 8));
        parkingService.save(new Parking(3L, "Parking 3", "Description of Parking 3", 34.0522, -118.2437, 12));
        parkingService.save(new Parking(4L, "Parking 4", "Description of Parking 4", 34.0522, -118.2437, 15));
        parkingService.save(new Parking(5L, "Parking 5", "Description of Parking 5", 34.0522, -118.2437, 5));

//        sessionService.save(new Session(1L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(2L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(3L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(4L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(5L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(6L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(7L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(8L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(9L, 34.0522, -118.2437, true));
//        sessionService.save(new Session(10L, 34.0522, -118.2437, true));
    }
}
