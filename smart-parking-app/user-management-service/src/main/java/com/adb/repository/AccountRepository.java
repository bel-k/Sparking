package com.adb.repository;

import com.adb.model.Account;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AccountRepository extends MongoRepository<Account,Long> {
    Optional<Account> findByLogin(String login);

}
