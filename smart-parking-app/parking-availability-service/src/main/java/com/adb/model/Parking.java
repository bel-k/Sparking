package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

import java.io.Serializable;



@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Parking implements Serializable {
   @Id
    private Long id ;
    private  String name;
    private String description ;
    private Boolean availabilityStatus;//construction


}
