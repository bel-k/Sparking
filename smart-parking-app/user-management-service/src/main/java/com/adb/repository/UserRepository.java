package com.adb.repository;

import com.adb.model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends MongoRepository<User,Long> {
    @Override
    List<User> findAll();
}
