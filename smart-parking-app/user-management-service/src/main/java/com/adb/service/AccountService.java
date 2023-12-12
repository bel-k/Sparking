package com.adb.service;

import com.adb.model.Account;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service

public interface AccountService {
    Optional<Account> loadUserLogin(String login) throws UsernameNotFoundException;
    UserDetailsService userDetailsService();
    Account save(Account newA);
}
