package com.adb.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@NoArgsConstructor
@AllArgsConstructor
@Entity

public class Parking implements Serializable {
    @Id
    private Long id;

    private String name;

    private String description;

    private Boolean availabilityStatus;

    @OneToMany(mappedBy = "parking")
    @JsonIgnoreProperties({"parking"})
    private List<Spot> spots;

    @OneToOne
    @JoinColumn(name = "location_id")
    private Location location;

    public Map<String, Object> mapParking()
    {
        Map<String,Object> map = new HashMap<>();
        map.put("id", id);
        map.put("name", this.name);
        map.put("description", this.description);
        map.put("availibilityStatus", this.availabilityStatus);
        map.put("location", this.location.mapLocation());
        return map;
    }

    public Location getLocation() {
        return location;
    }
}
