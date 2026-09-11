import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/network/api_service.dart';
import 'package:e_commerce_mall/core/utils/pref_helper.dart';
import 'package:e_commerce_mall/features/auth/data/user_model.dart';

class AuthRepo {
  final ApiService apiService = ApiService();

  // login
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await apiService.post(
        '/auth/login',
        data: {
          "username": username,
          "password": password,
        },
      );
      final user = UserModel.fromJson(response);
      if (user.token != null && user.token!.isNotEmpty) {
        await PrefHelper.saveToken(user.token!);
        // Store the user ID required by endpoints such as order history.
        await PrefHelper.saveUserId(user.id);
      }
      return user;
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // signUp
  Future<UserModel?> signUp(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await apiService.post(
        '/users/add',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "username": username,
          "email": email,
          "password": password,
        },
      );

      final user = UserModel.fromJson(response);
      return user;
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // Get Profile data
  Future<UserModel?> getProfile() async {
    try {
      final response = await apiService.get('/auth/me');
      return UserModel.fromJson(response);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // update profile data
  Future<UserModel?> updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final response = await apiService.put(
        '/users/$id',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
        },
      );
      return UserModel.fromJson(response);
    } on ApiError {
      rethrow;
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}