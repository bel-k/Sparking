package com.adb.service.impl;


import com.adb.model.Notification;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class PushNotificationService {
    private final Logger logger = LoggerFactory.getLogger(PushNotificationService.class);
    private final FCMService fcmService;

    public void sendPushNotificationToToken(Notification request) {
        try {
            fcmService.sendMessageToToken(request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }

}