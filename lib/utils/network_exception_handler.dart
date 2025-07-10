import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkExceptionHandler {
  // Process and provide meaningful error messages for network exceptions
  static String handleError(dynamic error) {
    String errorMessage = 'An unexpected error occurred';
    
    try {
      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection timed out. Please check your internet connection';
            break;
          case DioExceptionType.sendTimeout:
            errorMessage = 'Send timeout. Please try again';
            break;
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Receive timeout. Please try again';
            break;
          case DioExceptionType.cancel:
            errorMessage = 'Request was cancelled';
            break;
          case DioExceptionType.unknown:
            if (error.error is SocketException) {
              errorMessage = 'No internet connection. Please check your network settings';
            } else {
              errorMessage = 'Unexpected error: ${error.message}';
            }
            break;
          case DioExceptionType.badCertificate:
            errorMessage = 'Bad certificate. Please contact support';
            break;
          case DioExceptionType.badResponse:
            errorMessage = _handleBadResponseError(error.response?.statusCode, error.response?.data);
            break;
          case DioExceptionType.connectionError:
            errorMessage = 'Connection error. Please check your internet connection';
            break;
        }
      } else if (error is SocketException) {
        errorMessage = 'No internet connection. Please check your network settings';
      } else if (error is FormatException) {
        errorMessage = 'Invalid data format. Please contact support';
      } else if (error is HttpException) {
        errorMessage = 'An HTTP error occurred. Please try again';
      } else if (error is TimeoutException) {
        errorMessage = 'Operation timed out. Please try again';
      } else {
        errorMessage = 'Unexpected error: $error';
      }
    } catch (e) {
      // Fallback if error handling itself fails
      errorMessage = 'Critical error occurred';
      print('🚨 Error while handling another error: $e');
    }
    
    print('🔴 Network Error: $errorMessage');
    return errorMessage;
  }

  // Helper method for handling HTTP error status codes
  static String _handleBadResponseError(int? statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input';
      case 401:
        return 'Unauthorized. Please log in again';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error. Please try again later';
      default:
        if (data != null && data is Map && data.containsKey('message')) {
          return data['message'];
        }
        return 'HTTP error $statusCode occurred';
    }
  }

  // Check if response is a session error (HTML instead of JSON)
  static bool isSessionError(dynamic response) {
    if (response is String) {
      final lowerCaseResponse = response.toLowerCase();
      return lowerCaseResponse.contains('<!doctype html>') || 
             lowerCaseResponse.startsWith('<html') ||
             lowerCaseResponse.contains('<head>');
    }
    return false;
  }
}
