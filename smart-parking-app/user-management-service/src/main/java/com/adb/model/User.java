package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "users")
public class User {
//    @Transient
//    public static final String SEQUENCE_NAME = "users_sequence";
    @Id
    @Field("_id")
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private String vehicleType;
    private boolean disabled;
}
