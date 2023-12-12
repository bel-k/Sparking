package com.adb.repository;

import com.adb.model.Session;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public interface SessionRepository extends MongoRepository<Session,Long> {
    Optional<Session> findByToken(String token);
    
    void deleteByToken(String token);
    List<Session> findByAccount_Id(Long accountId);
}
