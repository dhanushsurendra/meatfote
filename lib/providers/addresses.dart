import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meatforte/models/http_excpetion.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/providers/auth.dart';
import 'package:provider/provider.dart';

const BASE_URL = 'https://meatstack.herokuapp.com';
//const BASE_URL = 'http://192.168.0.12:3000';


class Address {
  String id;
  String userId;
  String businessName;
  String address;
  String phoneNumber;
  final String timeOfDelivery;

  Address({
    this.id,
    this.userId,
    @required this.businessName,
    @required this.phoneNumber,
    @required this.address,
    @required this.timeOfDelivery,
  });
}

class Addresses with ChangeNotifier {
  List<Address> _addresses = [];

  Address getAddress(String addressId) {
    return _addresses.firstWhere((element) => element.id == addressId);
  }

  Future<void> addAddress(
    BuildContext context,
    Map<String, dynamic> address,
  ) async {
    Uri url = Uri.parse('$BASE_URL/addAddress/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
        body: json.encode(address),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      _addresses.add(
        new Address(
          id: responseData['address']['_id'],
          userId: responseData['address']['user_id'],
          address: responseData['address']['address'],
          phoneNumber: responseData['address']['phone_number'],
          businessName: responseData['address']['business_name'],
          timeOfDelivery: responseData['address']['time_of_delivery'],
        ),
      );

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
          phoneNumber: responseData['addresses'][i]['phone_number'],
          userId: responseData['addresses'][i]['user_id'],
          address: responseData['addresses'][i]['address'],
          businessName: responseData['addresses'][i]['business_name'],
          timeOfDelivery: responseData['addresses'][i]['time_of_delivery'],
        );

        _loadedAddresses.add(address);
      }

      _addresses = _loadedAddresses;

      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    } on SocketException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteAddress(
      BuildContext context, String addressId, String userId) async {
    print(userId);
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/deleteAddress/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token,
        },
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
    return [..._addresses];
  }
}
