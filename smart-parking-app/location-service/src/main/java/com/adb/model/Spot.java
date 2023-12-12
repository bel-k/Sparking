package com.adb.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Spot implements Serializable{

    @Id
    private Long id;

    private int number;

    private float price;

    private Boolean availabilityStatus;

    @ManyToOne
    @JoinColumn(name = "parking_id")
    private Parking parking;

}
