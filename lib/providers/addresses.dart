import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';

import 'package:http/http.dart' as http;

const BASE_URL = 'http://192.168.0.9:3000';

class Address {
  String id;
  String userId;
  final String businessName;
  final String streetAddress;
  final String locality;
  final String landmark;
  final String city;
  final int pincode;
  final String phoneNumber;
  final String timeOfDelivery;

  Address({
    this.id,
    this.userId,
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
  Address _address;

  Address getAddress(String addressId) {
    return _addresses.firstWhere((element) => element.id == addressId);
  }

  Future<void> fetchAddress(String userId, String addressId) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/getAddress/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'userId': userId,
            'addressId': addressId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      final Address address = new Address(
        id: responseData['addresses']['_id'],
        userId: responseData['addresses']['use_id'],
        businessName: responseData['addresses']['business_name'],
        city: responseData['addresses']['city'],
        landmark: responseData['addresses']['landmark'],
        locality: responseData['addresses']['locality'],
        phoneNumber: responseData['addresses']['phone_number'],
        pincode: responseData['addresses']['pincode'],
        streetAddress: responseData['addresses']['street_address'],
        timeOfDelivery: responseData['addresses']['time_of_delivery'],
      );

      _address = address;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrUpdateAddress(
    Map<String, dynamic> address,
    String type,
  ) async {
    Uri url;
    if (type == 'ADD') {
      url = Uri.parse('$BASE_URL/addAddress/');
    } else if (type == 'UPDATE') {
      url = Uri.parse('$BASE_URL/updateAddress/');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(address),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      if (type == 'ADD') {
        if (responseData['address'] != null) {
          _addresses.add(
            new Address(
              id: responseData['address']['_id'],
              userId: responseData['address']['user_id'],
              businessName: responseData['address']['business_name'],
              city: responseData['address']['city'],
              locality: responseData['address']['locality'],
              landmark: responseData['address']['landmark'],
              phoneNumber:
                  responseData['address']['phone_number'].split(' ')[1],
              pincode: responseData['address']['pincode'],
              streetAddress: responseData['address']['street_address'],
              timeOfDelivery: responseData['address']['time_of_delivery'],
            ),
          );

          notifyListeners();
        }
      } else if (type == 'UPDATE') {
        if (responseData['address'] != null) {
          final _addressIndex = _addresses.indexWhere(
            (element) => element.id == responseData['address']['_id'],
          );

          _addresses.removeAt(_addressIndex);

          final Address _newAddresss = new Address(
            id: responseData['address']['_id'],
            userId: responseData['address']['user_id'],
            businessName: responseData['address']['business_name'],
            city: responseData['address']['city'],
            locality: responseData['address']['locality'],
            landmark: responseData['address']['landmark'],
            phoneNumber: responseData['address']['phone_number'].split(' ')[1],
            pincode: responseData['address']['pincode'],
            streetAddress: responseData['address']['street_address'],
            timeOfDelivery: responseData['address']['time_of_delivery'],
          );

          _addresses.insert(_addressIndex, _newAddresss);

          notifyListeners();
        }
      }
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
      print(_addresses.length);

      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteAddress(String addressId, String userId) async {
    print(userId);
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/deleteAddress/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'addressId': addressId,
            'userId': userId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 201) {
        throw HttpException(responseData['error']);
      }

      int addressIdIndex =
          _addresses.indexWhere((element) => element.id == addressId);
      _addresses.removeAt(addressIdIndex);

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
    print(_addresses.length);
    return [..._addresses];
  }
}
