package com.adb.controller;

import com.adb.model.Notification;
import com.adb.model.Parking;
import com.adb.model.SessionNotification;
import com.adb.service.impl.FCMService;
import com.adb.service.impl.ParkingServiceImpl;
import com.adb.service.impl.SessionNotificationServiceImpl;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/real-time-notifications")
@AllArgsConstructor
public class RealTimeNotificationsController {
    private final ParkingServiceImpl parkingService;
    private final SessionNotificationServiceImpl sessionNotificationService;
    private final SimpMessagingTemplate messagingTemplate;
    private final SessionNotificationServiceImpl notificationService;
    private final FCMService fcmService;
    @GetMapping("/all")
    public ResponseEntity<List<Parking>> getAllParkings() {
        List<Parking> parkings =parkingService.findAll();
        return ResponseEntity.ok(parkings);
    }
    @PostMapping("/{parkingId}/addFreeSpot")
    public ResponseEntity<String> addFreeSpot(@PathVariable Long parkingId) {
        parkingService.saveFreeSpotForParking(parkingId);
        return ResponseEntity.ok("Free spot added to the parking: ");
    }
    @PostMapping("/register")
    public ResponseEntity<String> registerRealTimeNotification(@RequestBody Map<String, String> requestBody) {
        // Retrieve values from the request body
        String token = requestBody.get("token");
        String sessionId = requestBody.get("sessionId");
        System.out.println("Received token: " + token+" Received sessionId: " + sessionId);
        fcmService.saveFCMToken(token,sessionId);
        return ResponseEntity.ok("well received");
    }

    @MessageMapping("/sendNotification")
    public void sendNotification(Notification notification) {
        messagingTemplate.convertAndSend("/topic/notifications", notification);
    }
    @GetMapping("/{sessionId}/notifications")
    public List<SessionNotification> getNotifications(@PathVariable String sessionId) {
        return sessionNotificationService.findNotificationsBySessionId(Long.parseLong(sessionId));
    }


    @PostMapping("/{notifId}/mark-as-read")
    public void markSessionNotificationAsRead(@PathVariable String notifId) {
        sessionNotificationService.markAsRead(Long.parseLong(notifId));
    }
}
