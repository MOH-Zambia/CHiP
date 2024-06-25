package com.argusoft.imtecho.spreadsheetloader.location;

/**
 *
 * @author avani
 */
public class LocationException extends Exception{
 
    private final String message;
    
    public LocationException(String message){
        super();
        this.message = message;
    }
    
    @Override
    public String toString(){
        return message;
    }
    
}
