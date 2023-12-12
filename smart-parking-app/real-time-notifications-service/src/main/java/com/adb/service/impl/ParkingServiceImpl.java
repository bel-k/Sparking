package com.adb.service.impl;

import com.adb.model.Notification;
import com.adb.model.Parking;
import com.adb.model.Session;
import com.adb.model.SessionNotification;
import com.adb.repository.ParkingRepository;
import com.adb.service.ParkingService;
import com.adb.util.RedisIdGenerator;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@AllArgsConstructor
public class ParkingServiceImpl implements ParkingService {
    private final ParkingRepository parkingRepository;
    private final SessionServiceImpl sessionService;
    private final NotificationServiceImpl notificationService;
    private final SessionNotificationServiceImpl sessionNotificationService;
    private final RedisIdGenerator redisIdGenerator;
    private final PushNotificationService pushNotificationService;
    private final FCMService fcmService;
    private final SimpMessagingTemplate messagingTemplate;

    //web socket templete
    @Autowired
    SimpMessagingTemplate template;
    @Override
    public void save(Parking parking) {
        parkingRepository.save(parking);
    }

    @Override
    public void saveFreeSpotForParking(Long parkingId) {
        Parking parking = parkingRepository.findById(parkingId);
        if (parking != null){
            parking.setNbAvailableSpots(parking.getNbAvailableSpots()+1);
            parkingRepository.save(parking);
            // Find nearby sessions
            List<Session> nearbySessions = sessionService.findNearbySessions(parking.getLatitude(), parking.getLongitude());
            // Create and send notifications to nearby sessions
            String message = "Free spot available at " + parking.getName();
            for (Session session : nearbySessions) {
                if(session.isAuthenticated()){
                    String firebaseToken = fcmService.getTokenList().get(session.getId());
                    Notification notification = Notification.builder()
                            .id(redisIdGenerator.generateNUniqueId())
                            .title("New Spot Available")
                            .message(message)
                            .topic("spot_available_topic")
                            .token(firebaseToken)
                            .parking(parking)
                            .build();
                    notificationService.save(notification);
                    SessionNotification sessionNotification = SessionNotification.builder()
                            .id(redisIdGenerator.generateSNUniqueId())
                            .session(session)
                            .notification(notification)
                            .dateTime(LocalDateTime.now())
                            .isRead(false)
                            .build();
                    sessionNotificationService.save(sessionNotification);
                    pushNotificationService.sendPushNotificationToToken(notification);
                    template.convertAndSend("/topic/message", sessionNotification);
                    //messagingTemplate.convertAndSendToUser(session.getId().toString(), "/queue/notifications", notification);
                }
                //}
            }
        }
    }
    @Override
    public List<Parking> findAll() {
        return parkingRepository.findAll();
    }
}
