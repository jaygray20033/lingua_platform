package com.lingua.dto;

public class ApiResponse<T> {
    public boolean success;
    public T data;
    public String message;

    public ApiResponse(boolean success, T data, String message) {
        this.success = success;
        this.data = data;
        this.message = message;
    }
}
