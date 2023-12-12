package com.adb.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "sessions")
public class Session {
    @Id
    @Field("_id")
    private Long id;
    private Date startTime;
    private Date endTime;
    private String token;
    @DBRef
    private Account account;
    private boolean isAuthenticated;
}
