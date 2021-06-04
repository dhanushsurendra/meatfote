import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.5:3000';

class Address {
  final String id;
  final String userId;
  final String businessName;
  final String streetAddress;
  final String locality;
  final String landmark;
  final String city;
  final int pincode;
  final String phoneNumber;
  final String timeOfDelivery;

  Address({
    @required this.id,
    @required this.userId,
    @required this.businessName,
    @required this.streetAddress,
    @required this.locality,
    @required this.landmark,
    @required this.city,
    @required this.phoneNumber,
    @required this.pincode,
    @required this.timeOfDelivery,
  });
}

class Addresses with ChangeNotifier {

  List<Address> _addresses = [];

  Address getAddress(String addressId) {
    return _addresses.firstWhere((element) => element.id == addressId);
  }

  Future<void> addAddress(Map<String, dynamic> address) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/addAddress/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(address),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      print(responseData);

      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAddresses(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/getAddresses/$userId'),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      List<Address> _loadedAddresses = [];

      for (int i = 0; i < responseData['addresses'].length; i++) {
        final Address address = new Address(
          id: responseData['addresses'][i]['_id'],
          userId: responseData['addresses'][i]['use_id'],
          businessName: responseData['addresses'][i]['business_name'],
          city: responseData['addresses'][i]['city'],
          landmark: responseData['addresses'][i]['landmark'],
          locality: responseData['addresses'][i]['locality'],
          phoneNumber: responseData['addresses'][i]['phone_number'],
          pincode: responseData['addresses'][i]['pincode'],
          streetAddress: responseData['addresses'][i]['street_address'],
          timeOfDelivery: responseData['addresses'][i]['time_of_delivery'],
        );

        _loadedAddresses.add(address);
      }

      _addresses = _loadedAddresses;

      print(_addresses);

      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  List<Address> get addresses {
    return [..._addresses];
  }
}
