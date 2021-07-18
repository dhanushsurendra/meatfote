import 'dart:convert';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';

const BASE_URL = 'http://192.168.0.8:3000';

class User extends ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String businessName;
  final String establishmentYear;
  final String identifer;
  final String imageUrl;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.businessName,
    this.establishmentYear,
    this.identifer,
    this.imageUrl,
  });

  String userName;
  String userEmail;
  String userPhoneNumber;
  String userBusinessName;
  String userEstablishmentYear;
  String userIdentifier;
  String userBusinessType;
  String userImageUrl;
  String isProfileVerified;
  bool isImageUploadSuccess = false;

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
      userImageUrl = responseData['user']['profile_image_url'];
      isProfileVerified = responseData['user']['profile_verification_status'];

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
        headers: {
          'Content-Type': 'application/json',
        },
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
      userImageUrl = responseData['user']['profile_image_url'];

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
      userBusinessType = responseData['user']['business_type'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserBusinessDetails(
    String shopName,
    String businessType,
    String userId,
    String establishmentYear,
  ) async {
    // if (userBusinessName == shopName &&
    //     userEstablishmentYear == establishmentYear &&
    //     businessType == businessType) {
    //   return;
    // }

    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/businessDetails',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'userId': userId,
            'shopName': shopName,
            'establishmentYear': establishmentYear,
            'businessType': businessType,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      userBusinessName = responseData['user']['shop_name'];
      userEstablishmentYear = responseData['user']['establishment_year'];
      userBusinessType = responseData['user']['business_type'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> uploadDocument(
    File file,
    String userId, {
    String documentType,
    String document,
  }) async {

    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/uploadDocument/$userId/${p.extension(file.path)}',
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      Dio dio = new Dio();
      var len = await file.length();
      dio.options.headers['Content-Type'] = 'image/jpeg';
      var responseAWS = await dio.put(
        responseData['url'],
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: len,
          },
        ),
      );

      if (responseAWS.statusCode == 200) {
        try {
          final responseImageUrl = await http.post(
            Uri.parse(
              '$BASE_URL/postImageUrl/',
            ),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
              {
                'userId': userId,
                'imageUrl': responseData['key'],
                'documentType': documentType != null ? documentType : null,
                'document': document != null ? document : null,
              },
            ),
          );

          final responseImageUrlData = json.decode(responseImageUrl.body);

          if (responseImageUrlData['statusCode'] != 201) {
            isImageUploadSuccess = false;
            throw HttpException(responseImageUrlData['error']);
          }

          isImageUploadSuccess = true;
          notifyListeners();
        } catch (error) {
          throw error;
        }
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
