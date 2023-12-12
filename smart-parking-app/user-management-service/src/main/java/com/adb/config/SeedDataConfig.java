package com.adb.config;//package com.adb.config;
//
//import com.adb.model.Account;
//import com.adb.model.User;
//import com.adb.repository.AccountRepository;
//import com.adb.repository.UserRepository;
//import com.adb.service.AccountService;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.boot.CommandLineRunner;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Component;
//
//import java.util.Date;
//
//@Component
//@RequiredArgsConstructor
//@Slf4j
//public class SeedDataConfig implements CommandLineRunner {
//    private final AccountRepository accountRepository;
//    private final UserRepository userRepo;
//    private final PasswordEncoder passwordEncoder;
//    private final AccountService accountService;
//
//    @Override
//    public void run(String... args){
//        if (accountRepository.count() == 0) {
//            User u = User
//                    .builder()
//                    .firstName("admin")
//                    .lastName("admin")
//                    .email("admin@admin.com")
//                    .phoneNumber("0693863901")
//                    .build();
//            u = userRepo.save(u);
//            Account admin = Account
//                    .builder()
//                    .login("admin@admin.com")
//                    .password(passwordEncoder.encode("password"))
//                    .creationDate(new Date(System.currentTimeMillis()))
//                    .user(u)
//                    .build();
//
//            accountService.save(admin);
//            log.debug("created ADMIN user - {}", admin);
//        }
//    }
//}
//
