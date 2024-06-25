package com.argusoft.imtecho.common.util;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.util.Date;

public class DateDeserializer implements JsonDeserializer<Date> {
    @Override
    public Date deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        // Convert the timestamp string to a long value
        long timestamp = json.getAsLong();
        
        // Create a Date object from the timestamp
        return new Date(timestamp);
    }
}