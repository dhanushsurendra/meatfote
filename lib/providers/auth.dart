import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = 'http://192.168.0.8:8080';

class Auth extends ChangeNotifier {
  String _userId;
  String _token;
  String errorMessage = '';

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> login(
    String emailPhoneNumber,
    String password,
    String identifier,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'emailPhoneNumber': emailPhoneNumber,
            'password': password,
            'identifier': identifier,
          },
        ),
      );

      final responseData = json.decode(response.body);

      print(responseData);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      _userId = responseData['userId'];
      _token = responseData['token'];

      final userData = json.encode({
        'userId': _userId,
        'token': _token,
      });

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('userData', userData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(
    String emailPhoneNumber,
    String password,
    String identifier,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/signUp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'emailPhoneNumber': emailPhoneNumber,
            'password': password,
            'identifier': identifier,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      _userId = responseData['userId'];
      _token = responseData['token'];

      final userData = json.encode({
        'userId': _userId,
        'token': _token,
      });

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('userData', userData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoSignIn() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    if (!sharedPrefs.containsKey('userData')) {
      return false;
    }

    final extractedData =
        json.decode(sharedPrefs.getString('userData')) as Map<String, Object>;

    _token = extractedData['token'];
    _userId = extractedData['userId'];

    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    notifyListeners();
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }

  Future<void> sendOTP(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/sendOTP/$email'),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URL/verifyOTP'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': email,
            'otp': otp,
          }));

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> resetPassword(
    String newPassword,
    String email,
    bool isInApp, {
    String currentPassword = '',
    String userId = '',
  }) async {

    final url =
        !isInApp ? '$BASE_URL/resetPassword' : '$BASE_URL/changePassword';

    final data = !isInApp
        ? {
            'email': email,
            'newPassword': newPassword,
          }
        : {
            'newPassword': newPassword,
            'currentPassword': currentPassword,
            'userId': userId,
          };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
