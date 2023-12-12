package com.adb.repository;

import com.adb.model.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SessionRepository extends JpaRepository<Session,Long> {

    @Query("SELECT s FROM Session s WHERE ST_DWithin(s.location.locationGeometry, ST_MakePoint(:lng, :lat), :distance) = true")
    List<Session> findNearbySessions(@Param("lng") double lng, @Param("lat") double lat, @Param("distance") double distance);

}
