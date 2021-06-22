import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';

const BASE_URL = 'http://192.168.0.8:8080';

class User extends ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String businessName;
  final String establishmentYear;
  final String identifer;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.businessName,
    this.establishmentYear,
    this.identifer,
  });

  String userName;
  String userEmail;
  String userPhoneNumber;
  String userBusinessName;
  String userEstablishmentYear;
  String userIdentifier;

  Future<void> getUserPersonalDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$BASE_URL/personalDetails/$userId',
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      userName = responseData['user']['name'];
      userEmail = responseData['user']['email'];
      userPhoneNumber = responseData['user']['phone_number'];
      userIdentifier = responseData['user']['identifier'];

      print(responseData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserPersonalDetails(
    String name,
    String userId,
    String email,
    String phoneNumber,
    // later add file to upload
  ) async {
    if (userName == name &&
        phoneNumber == userPhoneNumber &&
        userEmail == email) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/personalDetails',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'userId': userId,
            'name': name,
            'email': email,
            'phoneNumber': phoneNumber,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      userName = responseData['user']['name'];
      userEmail = responseData['user']['email'];
      userPhoneNumber = responseData['user']['phone_number'];
      
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUserBusinessDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$BASE_URL/businessDetails/$userId',
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      userBusinessName = responseData['user']['shop_name'];
      userEstablishmentYear = responseData['user']['establishment_year'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserBusinessDetails(
    String shopName,
    String userId,
    String establishmentYear,
    // later add file to upload
  ) async {
    if (userBusinessName == shopName &&
        userEstablishmentYear == establishmentYear) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/businessDetails',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'userId': userId,
            'shopName': shopName,
            'establishmentYear': establishmentYear,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      userBusinessName = responseData['user']['shop_name'];
      userEstablishmentYear = responseData['user']['establishment_year'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
