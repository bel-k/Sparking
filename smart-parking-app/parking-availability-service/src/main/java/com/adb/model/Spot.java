package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Reference;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Spot implements Serializable{
    @Id
    private Long spotId ;
    private  int number;
    private float price;
    private Boolean availabilityStatus;
    private String vehicleType;
    private Boolean disabled ;
    @Reference
    private Parking parking;


}
