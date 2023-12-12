package com.adb.dicoveryserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class DiscoveryServerApplication
{
    public static void main( String[] args )
    {
        SpringApplication.run(DiscoveryServerApplication.class, args);
        //add in each service this dependency
        //eureka-client
        //in application
        //add @enableeruekaclient
        //in the .properties file
        //eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka
        //spring.application.name=xxx-service
        //try to change the port of any service to random service.port=0
        //then activate the allow parallele run from the edit to allow multiple instances
        //add config package , WebCLientCOnfig class, WebClient.Builder....
    }
}
