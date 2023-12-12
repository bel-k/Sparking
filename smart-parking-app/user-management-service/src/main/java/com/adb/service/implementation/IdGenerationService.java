package com.adb.service.implementation;

import com.adb.model.Sequence;
import com.adb.repository.SequenceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class IdGenerationService {
    private final SequenceRepository sequenceRepository;
    public Long generateNextId(String sequenceName) {
        Sequence sequence = sequenceRepository.findSequenceById(sequenceName);
        if (sequence == null) {
            sequence = new Sequence();
            sequence.setId(sequenceName);
            sequence.setSeq(1L);
        } else {
            sequence.setSeq(sequence.getSeq() + 1);
        }

        sequenceRepository.save(sequence);
        return sequence.getSeq();
    }
}

