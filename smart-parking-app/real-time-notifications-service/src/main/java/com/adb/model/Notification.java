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
public class Notification implements Serializable {
    private static final long serialVersionUID = -6574536861732053572L;
    @Id
    private Long id;
    private String title;
    private String message;
    private String topic;
    private String token;
    private Parking parking;
}
