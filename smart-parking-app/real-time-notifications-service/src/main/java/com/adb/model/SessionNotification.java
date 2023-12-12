package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Reference;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionNotification implements Serializable {
    private static final long serialVersionUID = -6574536861732053572L;

    @Id
    private Long id;
    @Reference
    private Session session;
    @Reference
    private Notification notification;
    private LocalDateTime dateTime;
    private boolean isRead ;
}
