package com.adb.service.impl;

import com.adb.model.Notification;
import com.google.firebase.messaging.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import lombok.Getter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class FCMService {
    private Logger logger = LoggerFactory.getLogger(FCMService.class);
    @Getter
    Map<Long, String>  tokenList = new HashMap<>();


    public void sendMessageToToken(Notification request)
            throws InterruptedException, ExecutionException {
        Message message = getPreconfiguredMessageToToken(request);
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String jsonOutput = gson.toJson(message);
        String response = sendAndGetResponse(message);
        logger.info("Sent message to token. Device token: " + request.getToken() + ", " + response+ " msg "+jsonOutput);
    }

    private String sendAndGetResponse(Message message) throws InterruptedException, ExecutionException {
        return FirebaseMessaging.getInstance().sendAsync(message).get();
    }


    private AndroidConfig getAndroidConfig(String topic) {
        return AndroidConfig.builder()
                .setTtl(Duration.ofMinutes(2).toMillis()).setCollapseKey(topic)
                .setPriority(AndroidConfig.Priority.HIGH)
                .setNotification(AndroidNotification.builder()
                        .setTag(topic).build()).build();
    }
    private ApnsConfig getApnsConfig(String topic) {
        return ApnsConfig.builder()
                .setAps(Aps.builder().setCategory(topic).setThreadId(topic).build()).build();
    }
    private Message getPreconfiguredMessageToToken(Notification request) {
        return getPreconfiguredMessageBuilder(request).setToken(request.getToken())
                .build();
    }
    private Message getPreconfiguredMessageWithoutData(Notification request) {
        return getPreconfiguredMessageBuilder(request).setTopic(request.getTopic())
                .build();
    }
    private Message getPreconfiguredMessageWithData(Map<String, String> data, Notification request) {
        return getPreconfiguredMessageBuilder(request).putAllData(data).setToken(request.getToken())
                .build();
    }
    private Message.Builder getPreconfiguredMessageBuilder(Notification request) {
        AndroidConfig androidConfig = getAndroidConfig(request.getTopic());
        ApnsConfig apnsConfig = getApnsConfig(request.getTopic());

        com.google.firebase.messaging.Notification notification = com.google.firebase.messaging.Notification.builder()
                .setTitle(request.getTitle())
                .setBody(request.getMessage())
                .build();

        return Message.builder()
                .setApnsConfig(apnsConfig)
                .setAndroidConfig(androidConfig)
                .setNotification(notification);
    }
    public void saveFCMToken(String token,String sessionId) {
        tokenList.put(Long.parseLong(sessionId),token);
    }


}