package com.adb;

import com.adb.service.AccountService;
import com.adb.service.implementation.AccountServiceImpl;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@EnableDiscoveryClient
@PropertySource("classpath:application-local.properties")
public class UserManagementServiceApplication
{
    public static void main( String[] args )
    {
        SpringApplication.run(UserManagementServiceApplication.class, args);
    }
}
