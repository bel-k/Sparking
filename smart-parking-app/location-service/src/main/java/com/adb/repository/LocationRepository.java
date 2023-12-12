package com.adb.repository;

import com.adb.model.Location;
import com.adb.model.Parking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LocationRepository extends JpaRepository<Location,Long> {

    @Query("SELECT l.parking FROM Location l WHERE ST_DWithin(l.locationGeometry, ST_MakePoint(:lng, :lat), :distance) = true")
    List<Parking> findNearbyParkings(@Param("lng") double lng, @Param("lat") double lat, @Param("distance") double distance);

}
