import 'package:e_commerce_mall/core/network/api_exceptions.dart';
import 'package:e_commerce_mall/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  // GET
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioClient.dio.get(endPoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  // Sends POST requests with parameters in the request body.
  Future<dynamic> post(String endPoint, {Object? data}) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  // PUT
  Future<dynamic> put(String endPoint, {Object? data}) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  // DELETE
  Future<dynamic> delete(String endPoint, {Object? data}) async {
    try {
      final response = await _dioClient.dio.delete(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}