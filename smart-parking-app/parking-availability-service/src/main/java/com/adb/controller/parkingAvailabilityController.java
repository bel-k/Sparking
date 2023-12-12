package com.adb.controller;
import com.adb.model.Parking;
import com.adb.model.Spot;
import com.adb.service.ParkingService;
import com.adb.service.SpotsService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.function.StreamBridge;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;


import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/parking-availability")
@RequiredArgsConstructor
public class parkingAvailabilityController {
    // services
    @Autowired
    private  SpotsService spotService;
    @Autowired
    private ParkingService parkingService;
    //web socket templete
    @Autowired
    SimpMessagingTemplate template;
    // kafka Stream Bridge
    @Autowired
    private StreamBridge streamBridge;


    /*********************************parking mapping********************************************************/
    //add a parking
   @PostMapping("/parking")
   public ResponseEntity<String> saveParking(@RequestBody Parking parking) {
        boolean result = parkingService.saveParking(parking);
        if (result)
            return ResponseEntity.ok("parking Created Successfully!!");
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("can t post");
   }
    // get all parking
    @GetMapping("/parking")
    @ResponseBody

    public ResponseEntity<List<Parking>> fetchAllParking() {
        List<Parking> parkingList = parkingService.fetchAllParking();
        return ResponseEntity.ok(parkingList);
    }
    //get a parking by id
    @GetMapping("/parking/{id}")
    public ResponseEntity<Parking> fetchParkingById(@PathVariable("id") Long id) {
        Parking parking = parkingService.fetchParkingById(id);
        return ResponseEntity.ok(parking);
    }
    //delete a parking
    @DeleteMapping("/parking/{id}")
    public ResponseEntity<String> deleteParking(@PathVariable("id") Long id) {
        boolean result = parkingService.deleteParking(id);
        if(result)
            return ResponseEntity.ok("parking deleted Successfully!!");
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    //update a parking **put**
    @PutMapping("/parking/{id}")
    public ResponseEntity<String> updateParking(@PathVariable("id") Long id, @RequestBody Parking parking) {
        boolean result = parkingService.updateParking(id,parking);
        if(result)
            return ResponseEntity.ok("parking Updated Successfully!!");
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    //update a parking **put**
    @PatchMapping("/parking/{id}")
    public ResponseEntity<String> patchParking(@PathVariable("id") Long id, @RequestBody Map<String, Object> updates) {
        boolean result = parkingService.patchParking(id, updates);
        if(result){
           return ResponseEntity.ok("parking Updated Successfully!!");}
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    /*********************************spots mapping********************************************************/
    //add a spot
    @PostMapping("/spot")
    public ResponseEntity<String> saveSpot(@RequestBody Spot spot) {
        boolean result = spotService.saveSpot(spot);
        if (result)
            return ResponseEntity.ok("spot Created Successfully!!");
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("can t post");
    }
    //get spots
    @GetMapping("/spot")
    @ResponseBody
    public ResponseEntity<List<Spot>> fetchAllSpots() {

            List<Spot> spots= spotService.fetchAllSpot();
            return ResponseEntity.ok(spots);
        }
    //get a spot by id
    @GetMapping("/spot/{id}")
    public ResponseEntity<Spot> fetchSpotById(@PathVariable("id") Long id) {
        Spot spot;
        spot = spotService.fetchSpotById(id);
        return ResponseEntity.ok(spot);
    }
    //delete a spot
    @DeleteMapping("/spot/{id}")
    public ResponseEntity<String> deleteSpot(@PathVariable("id") Long id) {
        boolean result = spotService.deleteSpot(id);
        if(result)
            return ResponseEntity.ok("spot deleted Successfully!!");
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    //update a spot **patch**
    @PatchMapping("/spot/{id}")
    public ResponseEntity<String> patchSpot(@PathVariable("id") Long id, @RequestBody Map<String, Object> updates) {
        boolean result = spotService.patchSpot(id, updates);
        Spot spotUpdated=spotService.fetchSpotById(id);
        if(result){
            //send the updated spot to real tme update service
           // streamBridge.send("P3TOP4",spotUpdated);
            List<Spot> spots;
            spots = spotService.fetchAllSpot();
            //send list of spot to the front end
            template.convertAndSend("/topic/message", spots);
            return ResponseEntity.ok("spot Updated Successfully!!");}
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }
    // find all spots in a parking
    @GetMapping("/spot/findSpotInParking/{id}")
    public List<Spot> getSpotsInParking1(@PathVariable("id") Long parkingId) {
        return spotService.getSpotsByParkingId(parkingId);
    }
    //update a spot  **put**
    @PutMapping("/spot/{id}")
    public ResponseEntity<String> updateSpot(@PathVariable("id") Long id, @RequestBody Spot spot) {
        boolean result = spotService.updateSpot(id,spot);
        if(result){
            //send the updated spot to real tme update service
            streamBridge.send("P3TOP4",spot);
            List<Spot> spots;
            spots = spotService.fetchAllSpot();
            //send list of spot to the front end
            template.convertAndSend("/topic/message", spots);
            return ResponseEntity.ok("spot Updated Successfully!!");}
        else
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
    }

    /*********************************web socket handler********************************************************/
    @MessageMapping("/sendMessage")
    public void receiveMessage(@Payload List<Spot>  spots) {
        // receive message from client

    }
     @SendTo("/topic/message")
     public List<Spot> broadcastMessage(@Payload List<Spot>  spots) {
        return spots;
    }

}