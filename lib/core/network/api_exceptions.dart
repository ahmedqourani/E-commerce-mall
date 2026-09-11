import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:dio/dio.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(message: 'Connection timeout');

      case DioExceptionType.connectionError:
        return ApiError(message: 'Cannot connect to server');

      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return ApiError(message: 'Bad request');

          case 401:
            return ApiError(message: 'Invalid username or password');

          case 403:
            return ApiError(
              message: 'You are not allowed to access this resource',
            );

          case 404:
            return ApiError(message: 'Resource not found');

          case 500:
            return ApiError(message: 'Server error');

          default:
            return ApiError(message: 'Something went wrong');
        }

      case DioExceptionType.cancel:
        return ApiError(message: 'Request cancelled');

      default:
        return ApiError(message: 'Something went wrong');
    }
  }
}
