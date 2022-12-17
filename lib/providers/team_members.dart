import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:meatforte/providers/auth.dart';
import 'package:provider/provider.dart';

const BASE_URL = 'https://meatstack.herokuapp.com';
//const BASE_URL = 'http://192.168.0.12:3000';

class TeamMember {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;

  TeamMember({
    @required this.id,
    @required this.userId,
    @required this.name,
    @required this.phoneNumber,
  });
}

class TeamMembers extends ChangeNotifier {
  List<TeamMember> _teamMembers = [];
  String _ownerName = '';
  String _ownerPhoneNumber = '';

  String get ownerName {
    return _ownerName;
  }

  String get ownerPhoneNumber {
    return _ownerPhoneNumber;
  }

  List<TeamMember> get teamMembers {
    return [..._teamMembers];
  }

  Future<void> fetchTeamMembers(
    BuildContext context,
    String userId,
  ) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URL/teamMembers/$userId'), headers: {
        'Authorization':
            'Bearer ' + Provider.of<Auth>(context, listen: false).token
      });

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      _ownerName = responseData['owner']['name'];
      _ownerPhoneNumber = responseData['owner']['phone_number'];

      List<TeamMember> _loadedTeamMembers = [];

      for (var i = 0; i < responseData['teamMembers'].length; i++) {
        final teamMember = new TeamMember(
            id: responseData['teamMembers'][i]['_id'],
            name: responseData['teamMembers'][i]['name'],
            phoneNumber: responseData['teamMembers'][i]['phone_number'],
            userId: responseData['teamMembers'][i]['user_id']);

        _loadedTeamMembers.add(teamMember);
      }

      _teamMembers = _loadedTeamMembers;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addTeamMember(
    BuildContext context,
    String userId,
    String name,
    String phoneNumber,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/addTeamMember/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token
        },
        body: json.encode(
          {
            'userId': userId,
            'name': name,
            'phoneNumber': phoneNumber,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      final teamMember = new TeamMember(
        id: responseData['teamMember']['_id'],
        name: responseData['teamMember']['name'],
        phoneNumber: responseData['teamMember']['phone_number'],
        userId: responseData['teamMember']['user_id'],
      );

      _teamMembers.add(teamMember);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteTeamMember(
    BuildContext context,
    String teamMemberId,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/deleteTeamMember/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' + Provider.of<Auth>(context, listen: false).token
        },
        body: json.encode(
          {
            'userId': userId,
            'teamMemberId': teamMemberId,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['statusCode'] != 200) {
        throw HttpException(responseData['error']);
      }

      final _teamMemberIndex =
          _teamMembers.indexWhere((element) => element.id == teamMemberId);
      _teamMembers.removeAt(_teamMemberIndex);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
