package com.adb;

//import com.adb.filter.AuthenticationFilter;
import jdk.jfr.Enabled;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.client.RestTemplate;


@SpringBootApplication
@PropertySource("classpath:application-local.properties")
public class App 
{
//    @Bean
//    public GlobalFilter myAuthenticationFilter() {
//        return new AuthenticationFilter(new RestTemplate());
//    }
//    @Bean
//    public RestTemplate restTemplate() {
//        return new RestTemplate();
//    }
    public static void main( String[] args )
    {
        SpringApplication.run(App.class, args);
    }
}
