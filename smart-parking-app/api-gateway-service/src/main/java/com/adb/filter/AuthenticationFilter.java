//package com.adb.filter;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.cloud.gateway.filter.GatewayFilterChain;
//import org.springframework.cloud.gateway.filter.GlobalFilter;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.stereotype.Component;
//import org.springframework.web.client.RestTemplate;
//import org.springframework.web.server.ServerWebExchange;
//import reactor.core.publisher.Mono;
//
//import java.util.Arrays;
//import java.util.List;
//
//@Component
//public class AuthenticationFilter implements GlobalFilter {
//
//    private static final List<String> UNAUTHENTICATED_PATHS = Arrays.asList(
//            "/api/user-management/signup",
//            "/api/user-management/signin",
//            "eureka/web"
//    );
//
//    private final RestTemplate restTemplate;
//
//    @Autowired
//    public AuthenticationFilter(RestTemplate restTemplate) {
//        this.restTemplate = restTemplate;
//    }
//
//    @Override
//    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
//        // Extract session token from request header
//        String sessionToken = exchange.getRequest().getHeaders().getFirst("Session-Token");
//
//        // Check if the requested path is unauthenticated
//        String requestPath = exchange.getRequest().getPath().value();
//        if (UNAUTHENTICATED_PATHS.contains(requestPath)) {
//            // Requested path is unauthenticated, proceed without validation
//            return chain.filter(exchange);
//        }
//
//        // Make a request to User Management Service for session token validation
//        String requestUrl = exchange.getRequest().getURI().toString();
//        if (requestUrl.contains("/api/user-management/signup") || requestUrl.contains("/api/user-management/signin")) {
//            // Add the request parameter for signup and signin paths
//            requestUrl += "?authRequired=true";
//        }
//
//        // Make the request with the modified URL
//        ResponseEntity<String> responseEntity = restTemplate.getForEntity(requestUrl, String.class);
//
//        if (responseEntity.getStatusCode() == HttpStatus.OK) {
//            // User is authenticated, proceed with the request
//            return chain.filter(exchange);
//        } else {
//            // Session token is invalid, return unauthorized response
//            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
//            return exchange.getResponse().setComplete();
//        }
//    }
//}
