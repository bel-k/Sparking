package com.adb.repository;

import com.adb.model.Sequence;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SequenceRepository extends MongoRepository<Sequence, String> {
    Sequence findSequenceById(String id);
}

