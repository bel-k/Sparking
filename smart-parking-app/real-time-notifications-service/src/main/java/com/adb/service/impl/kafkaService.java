package com.adb.service.impl;
import com.adb.model.Session;
import lombok.AllArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.util.function.Consumer;

@Service
@AllArgsConstructor
public class kafkaService{
    private final SessionServiceImpl sessionService;
    @Bean
    public Consumer<Session> sessionConsumer (){
        return (input)-> {
            System.out.println("*********1************");
            System.out.println(input.toString());
            Session s = sessionService.findById(input.getId());
            if(s != null)
            {
                System.out.println("Already exists ");
                s.setAuthenticated(input.isAuthenticated());
                sessionService.save(s);
            }
            else
            {
                System.out.println("New one");
                sessionService.save(input);
            }
            System.out.println("*********1************");

        };
    }
//    @Bean
//    public Consumer<Session> updateSessionConsumer(){
//        return (input)-> {
//            System.out.println("*********2************");
//            System.out.println(input.toString());
//            Session s = sessionService.findById(input.getId());
//            s.setActive(input.isActive());
//            sessionService.save(s);
//            System.out.println("***********2**********");
//        };
//    }
}

