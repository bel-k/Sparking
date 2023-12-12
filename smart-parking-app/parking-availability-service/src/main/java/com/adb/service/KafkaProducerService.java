package com.adb.service;


import com.adb.model.Spot;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service

public class KafkaProducerService {
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;
    @Autowired
    private KafkaTemplate<Spot, Spot> kafkaTemplateSpot;

     public void sendUpdate(String message) {
        kafkaTemplate.send("R50", message);
    }
    public void sendUpdateSpot(Spot Spot) {
        kafkaTemplateSpot.send("R50", Spot);
    }
}