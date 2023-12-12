package com.adb.repository;

import com.adb.model.Parking;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ParkingRepository extends JpaRepository<Parking,Long> {
}
