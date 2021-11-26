import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';
import 'package:meatforte/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = 'https://meatstack.herokuapp.com';

class Auth extends ChangeNotifier {
  String _userId;
  String _token;
  String errorMessage = '';
  bool _location;
  bool _isProfileCompleted = false;

  bool get isAuth {
    return _token != null && _isProfileCompleted;
  }

  String get token {
    return _token;
  }

  bool get location {
    return _location != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> login(
    String emailPhoneNumber,
    String password,
    String identifier
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'emailPhoneNumber': emailPhoneNumber,
            'password': password,
            'identifier': identifier,
            'role': 'user',
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        if (responseData['error'].toString().startsWith(
            'Your profile is not completed. Complete it to continue.')) {
          _userId = responseData['data']['userId'];
          _token = responseData['data']['token'];
          _isProfileCompleted = false;
          throw HttpException(responseData['error']);
        } else if (responseData['error']
            .toString()
            .startsWith('Your profile was rejected')) {
          _userId = responseData['data'];
          throw HttpException(responseData['error']);
        } else {
          throw HttpException(responseData['error']);
        }
      }

      _userId = responseData['userId'];
      _token = responseData['token'];
      _isProfileCompleted = true;

      final userData = json.encode({
        'userId': _userId,
        'token': _token,
        'isProfileCompleted': _isProfileCompleted
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
        if (responseData['error'].toString().startsWith(
            'Your profile is incomplete. Complete it to continue.')) {
          _userId = responseData['data']['userId'];
          _token = responseData['data']['token'];
          _isProfileCompleted = false;
          throw HttpException(responseData['error']);
        } else {
          throw HttpException(responseData['error']);
        }
      }

      _userId = responseData['userId'];

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
    _isProfileCompleted = extractedData['isProfileCompleted'];

    notifyListeners();

    return true;
  }

  Future<void> logout(BuildContext context) async {
    _userId = null;
    _token = null;
    _isProfileCompleted = false;

    // set the values to empty string when user logs out
    User user = new User();
    user.clearUserValues();

    notifyListeners();
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove('userData');
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

  Future<bool> fetchLocation() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    if (!sharedPrefs.containsKey('location')) {
      return false;
    }

    final extractedData = sharedPrefs.getBool('location');

    _location = extractedData;

    notifyListeners();

    return true;
  }
}
