package com.adb.helper;

import java.util.HashMap;
import java.util.Map;

public class RequestResponseHelper {

    public static Map<String, Object> success(Object res, int code, String message)
    {
        Map<String,Object> map = new HashMap<>();
        map.put("object", res);
        map.put("message", message);
        map.put("state", "success");
        map.put("code", code);
        return map;
    }
    public static Map<String, Object> error(Object res, int code, String message)
    {
        Map<String,Object> map = new HashMap<>();
        map.put("object", res);
        map.put("message", message);
        map.put("state", "error");
        map.put("code", code);
        return map;
    }




}
