package com.adb.service;

import com.adb.model.Notification;
import org.springframework.stereotype.Service;

@Service
public interface NotificationService {
    void save(Notification notification);

}
