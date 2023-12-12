package com.adb.service.implementation;

import com.adb.model.Session;
import lombok.AllArgsConstructor;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class PageEventProducer {
    private final KafkaTemplate<String, Session> kafkaTemplate;

    public void sendSessionEvent(Session session) {
        System.out.println("Producing Session event: " + session.toString());
        kafkaTemplate.send("S1TOS4", session);
    }
    /*public void sendUpdateSessionEvent(Session session) {
        System.out.println("Producing Update Session event: " + session.toString());
        kafkaTemplate.send("S1TOS42", session);
    }*/

}
