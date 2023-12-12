package com.adb.repository;

import com.adb.model.Spot;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SpotRepository extends JpaRepository<Spot,Long> {
}
