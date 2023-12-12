package com.adb.service.implementation;

import com.adb.model.User;
import com.adb.repository.UserRepository;
import com.adb.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    public List<User> getAllUsers(){
       return userRepository.findAll();
    }
}
