import 'dart:convert' show utf8, json;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../models/locations_model.dart';

class ApiService {
  Future<List<LocationsModel>?> getLocations(String startPoint) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + startPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        String locationResponse = json.encode(json
            .decode(utf8.decode(response.body.runes.toList()))["locations"]);
        List<LocationsModel>? model = LocationsModelFromJson(locationResponse);
        if (locationResponse.isNotEmpty) {
          if (kDebugMode) {
            print("store in locations prefs");
          }
          prefs.setString('locations', locationResponse);
        }
        return model;
      }
    } catch (e) {
      if (kDebugMode) {
        print("ApiService::${e.toString()}");
      }
    }
  }
}
