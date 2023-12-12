package com.adb.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Session implements Serializable {

    @Id
    private Long id;

    @OneToOne
    @JoinColumn(name = "location_id")
    private Location location;

}
