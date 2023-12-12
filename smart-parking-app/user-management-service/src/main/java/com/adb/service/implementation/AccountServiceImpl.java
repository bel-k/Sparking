package com.adb.service.implementation;

import com.adb.model.Account;
import com.adb.repository.AccountRepository;
import com.adb.service.AccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private AccountRepository accountRepo;
    @Autowired
    public AccountServiceImpl(AccountRepository accountRepo) {
        this.accountRepo = accountRepo;
    }

    @Override
    public Optional<Account> loadUserLogin(String login) throws UsernameNotFoundException {
        Optional<Account> account = accountRepo.findByLogin(login);
        if (account.isEmpty()) {
            throw new UsernameNotFoundException("Account not found: " + login);
        }
         return account;
    }


    @Override
    public UserDetailsService userDetailsService() {
        return username -> accountRepo.findByLogin(username)
                .orElseThrow(() -> new UsernameNotFoundException("Account not found: " + username));
    }

    @Override
    public Account save(Account newA) {
        return accountRepo.save(newA);
    }
}
