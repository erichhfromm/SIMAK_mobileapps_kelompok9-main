import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://api.freeapi.app/api/v1/';
  static final Dio _dio = Dio();

  // 🔥 GET RANDOM USERS (API GRATIS)
  static Future<Map<String, dynamic>> getRandomUsers() async {
    try {
      final response = await _dio.get("${baseUrl}public/randomusers");

      return {"status": true, "data": response.data};
    } on DioException catch (e) {
      return {"status": false, "error": e.response?.data ?? e.message};
    } catch (e) {
      return {"status": false, "error": e.toString()};
    }
  }

  // 🔹 API LOGIN
  static Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    try {
      bool isEmail = identifier.contains('@');
      final data = isEmail
          ? {"email": identifier, "password": password}
          : {"username": identifier, "password": password};

      final response = await _dio.post("${baseUrl}users/login", data: data);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return {"status": 200, "data": response.data['data']['accessToken']};
      }
      return {
        "status": response.statusCode,
        "error": response.data['message'] ?? "Login failed",
      };
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "error": e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {"status": 500, "error": e.toString()};
    }
  }

  // 🔹 API REGISTER
  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        "${baseUrl}users/register",
        data: {"username": username, "email": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": 200,
          "message": response.data['message'] ?? "Register success",
        };
      }
      return {
        "status": response.statusCode,
        "error": response.data['message'] ?? "Register failed",
      };
    } on DioException catch (e) {
      return {
        "status": e.response?.statusCode ?? 500,
        "error": e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {"status": 500, "error": e.toString()};
    }
  }

  // 🔹 SAVE TOKEN FOR DEMO
  static Future<void> saveToken(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token);
    await prefs.setString("auth_email", email);
  }
}
