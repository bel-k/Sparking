package com.adb.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.Point;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;


@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Location implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "geography")
    private Geometry locationGeometry;

    @OneToOne(mappedBy = "location")
    private Parking parking;

    @OneToOne(mappedBy = "location")
    private Session session;

    public Map<String, Object> mapLocation()
    {
        Map<String,Object> map = new HashMap<>();
        map.put("lat", this.locationGeometry.getCoordinate().x);
        map.put("lon", this.locationGeometry.getCoordinate().y);
       return map;
    }

    public Geometry getLocationGeometry() {
        return locationGeometry;
    }

    public void setLocationGeometry(Geometry locationGeometry) {
        this.locationGeometry = locationGeometry;
    }
}
