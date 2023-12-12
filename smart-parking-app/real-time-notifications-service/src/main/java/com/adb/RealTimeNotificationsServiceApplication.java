package com.adb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@EnableDiscoveryClient
@PropertySource("classpath:application-local.properties")
public class RealTimeNotificationsServiceApplication
{
    public static void main( String[] args )
    {
        SpringApplication.run(RealTimeNotificationsServiceApplication.class, args);
    }
}
