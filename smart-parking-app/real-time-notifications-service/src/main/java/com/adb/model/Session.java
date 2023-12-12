package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Session implements Serializable {
    private static final long serialVersionUID = -6574536861732053572L;

    @Id
    private Long id;
    private double latitude;
    private double longitude;
    private boolean activateNotification;
    private boolean isAuthenticated;
}
