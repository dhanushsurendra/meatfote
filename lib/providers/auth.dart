import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = 'http://192.168.0.8:3000';

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
}
