import 'dart:convert';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:meatforte/providers/auth.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/models/http_excpetion.dart';
import 'package:provider/provider.dart';

const BASE_URL = 'https://meatstack.herokuapp.com';
//const BASE_URL = 'http://192.168.0.12:3000';

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
  String userPersonalVerificationImageUrl;
  String userBusinessVerificationImageUrl;
  String userIdentifier;
  String userBusinessType;
  String userImageUrl;
  String isProfileVerified;
  bool isImageUploadSuccess = false;

  Future<void> getUserPersonalDetails(
    BuildContext context,
    String userId,
  ) async {

    try {
      final response = await http.get(
        Uri.parse(
          '$BASE_URL/personalDetails/$userId',
        ),
        headers: {
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
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
      userPersonalVerificationImageUrl =
          responseData['user']['personal_verification_image_url'];
      isProfileVerified = responseData['user']['profile_verification_status'];

      print(responseData);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserPersonalDetails(
    BuildContext context,
    String name,
    String userId,
    String email,
    String phoneNumber,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/personalDetails',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
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

  Future<void> getUserBusinessDetails(
    BuildContext context,
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/businessDetails/$userId'),
        headers: {
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }
      print(responseData);

      userBusinessName = responseData['user']['shop_name'];
      userEstablishmentYear = responseData['user']['establishment_year'];
      userBusinessType = responseData['user']['business_type'];
      userBusinessVerificationImageUrl =
          responseData['user']['business_verification_image_url'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> postUserBusinessDetails(
    BuildContext context,
    String shopName,
    String businessType,
    String userId,
    String establishmentYear,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/businessDetails'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
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
    BuildContext context,
    File file,
    String userId, {
    String documentType,
    String document,
  }) async {
    print('userId: ' + userId);
    try {
      final response = await http.post(
        Uri.parse(
          '$BASE_URL/uploadDocument/$userId/${p.extension(file.path)}',
        ),
        headers: {
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token
        },
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
              'Authorization':
                  'Bearer ' + Provider.of<Auth>(context, listen: false).token,
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

  void clearUserValues() {
    userName = null;
    userEmail = null;
    userPhoneNumber = null;
    userBusinessName = null;
    userEstablishmentYear = null;
    userPersonalVerificationImageUrl = null;
    userBusinessVerificationImageUrl = null;
    userIdentifier = null;
    userBusinessType = null;
    userImageUrl = null;
    isProfileVerified = null;
    notifyListeners();
  }
}
