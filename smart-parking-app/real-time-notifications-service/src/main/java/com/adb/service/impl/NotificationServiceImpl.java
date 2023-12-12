package com.adb.service.impl;

import com.adb.model.Notification;
import com.adb.repository.NotificationRepository;
import com.adb.service.NotificationService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class NotificationServiceImpl implements NotificationService {
    private final NotificationRepository notificationRepository;
    @Override
    public void save(Notification notification) {
        notificationRepository.save(notification);
    }

}
