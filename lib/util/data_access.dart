import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_app/util/impact.dart';
import 'package:project_app/util/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/models/steps.dart';
import 'package:project_app/models/heart.dart';
import 'package:project_app/models/patient.dart';
import '../database/patients/patients.dart';

class Data_Access {

  static Future<List<Patients>> getPatients() async{
    await Authentication.getAndStoreTokens();
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access'); //request access token, will be null if not present
    if(access == null){
      print('access is null');
      return List.empty();
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await Authentication.refreshTokens(); //refresh token if expired
        var access = sp.getString('access');
      }

      final url = Impact.baseUrl + Impact.patientEndpoint;

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $access' //user must be authenticated to access this endpoint
      };

      final response = await http.get(
            Uri.parse(url), 
            headers: headers);
            print(response);
      final List<Patients> result = [];
      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body);
        
        
        for(var i = 0; i < decodedResponse['data'].length; i++){
          final dataEntry = decodedResponse['data'][i];
          print(dataEntry);

          result.add(Patients(
            username: dataEntry['username'],
            birthyear : dataEntry['birth_year'],
            displayname : dataEntry['display_name']));
        }
      }
      return result;
    }
  } //getStep


static Future<List<Steps>> getStep() async{
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access'); //request access token, will be null if not present
    if(access == null){
      return List.empty();
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await Authentication.refreshTokens(); //refresh token if expired
        var access = sp.getString('access');
      }

      final day = '2023-05-15';
      final patient = 'Jpefaq6m58';
      final url = Impact.baseUrl + Impact.stepEndpoint + 'patients/$patient/' + 'day/$day/';

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $access' //user must be authenticated to access this endpoint
      };

      final response = await http.get(
            Uri.parse(url), 
            headers: headers);
      final List<Steps> result = [];
      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body);
        
        
        for(var i = 0; i < decodedResponse['data']['data'].length; i++){
          final dataEntry = decodedResponse['data']['data'][i];
          //result.add(Steps.fromJson(dataEntry));

          result.add(Steps(time: DateTime.parse(day + ' ' + dataEntry['time']), value: int.parse(dataEntry['value']), patient: patient));
        }
      }
      print(response.body);
      return result;
    }
  } //getStep

static Future<List<Heart>> getHeart() async{
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access'); //request access token, will be null if not present
    if(access == null){
      return List.empty();
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await Authentication.refreshTokens(); //refresh token if expired
        var access = sp.getString('access');
      }

      final patient = 'Jpefaq6m58';
      final day = '2023-05-15';
      final url = Impact.baseUrl + Impact.heartEndpoint + 'patients/Jpefaq6m58/' + 'day/$day/';

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $access' //user must be authenticated to access this endpoint
      };

      final response = await http.get(
            Uri.parse(url), 
            headers: headers); 
      final List<Heart> result = [];
      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body);
        
        
        for(var i = 0; i < decodedResponse['data']['data'].length; i++){
          final dataEntry = decodedResponse['data']['data'][i];

          result.add(Heart(time: DateTime.parse(day + ' ' + dataEntry['time']), value: dataEntry['value'], patient: patient));
        }
      }
      print(response.body);
      return result;
    }
  } //getHeart

  static Future<List<Steps>> getStepWeek(DateTime start, DateTime end, String patient) async{
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access'); //request access token, will be null if not present
    if(access == null){
      return List.empty();
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await Authentication.refreshTokens(); //refresh token if expired
        var access = sp.getString('access');
      }

      final start_date = "${start.year.toString()}-${start.month.toString().padLeft(2,'0')}-${start.day.toString().padLeft(2,'0')}";
      final end_date = "${end.year.toString()}-${end.month.toString().padLeft(2,'0')}-${end.day.toString().padLeft(2,'0')}";
      final url = Impact.baseUrl + Impact.stepEndpoint + 'patients/$patient/' + 'daterange/start_date/$start_date/' + 'end_date/$end_date/';

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $access' //user must be authenticated to access this endpoint
      };

      final response = await http.get(
            Uri.parse(url), 
            headers: headers);
      final List<Steps> result = [];
      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body);
        
        
        for(var i = 0; i < decodedResponse['data'].length; i++){
          final dayEntry = decodedResponse['data'][i];
          dayEntry['data'].forEach((dataEntry) {
            result.add(Steps(time: DateTime.parse(dayEntry['date'] + ' ' + dataEntry['time']), value: int.parse(dataEntry['value']), patient: patient));
          });
        }
      }

      return result;
    }
  } //getStepWeek

  static Future<List<Heart>> getHeartWeek(DateTime start, DateTime end, String patient) async{
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access'); //request access token, will be null if not present
    if(access == null){
      return List.empty();
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await Authentication.refreshTokens(); //refresh token if expired
        var access = sp.getString('access');
      }

      final start_date = "${start.year.toString()}-${start.month.toString().padLeft(2,'0')}-${start.day.toString().padLeft(2,'0')}";
      final end_date = "${end.year.toString()}-${end.month.toString().padLeft(2,'0')}-${end.day.toString().padLeft(2,'0')}";
      final url = Impact.baseUrl + Impact.heartEndpoint + 'patients/$patient/' + 'daterange/start_date/$start_date/' + 'end_date/$end_date/';

      final headers = {
        HttpHeaders.authorizationHeader: 'Bearer $access' //user must be authenticated to access this endpoint
      };

      final response = await http.get(
            Uri.parse(url), 
            headers: headers);
      final List<Heart> result = [];
      if(response.statusCode == 200){
        final decodedResponse = jsonDecode(response.body);
        
        
        for(var i = 0; i < decodedResponse['data'].length; i++){
          final dayEntry = decodedResponse['data'][i];
          dayEntry['data'].forEach((dataEntry) {
            result.add(Heart(time: DateTime.parse(dayEntry['date'] + ' ' + dataEntry['time']), value: dataEntry['value'], patient: patient));
          });
        }
      }

      return result;
    }
  } //getStepWeek
}//Data_Access