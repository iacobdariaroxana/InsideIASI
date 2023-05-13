import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:http/http.dart' as http;

class ImageApiService {
  // String url = 'http://192.168.143.121:5217/ImagePredictions';
  String url = 'http://192.168.143.121:5000/predict';
  Future<PointOfInterest?> detectPoi(String image64) async {
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image64": image64}));

    if (response.statusCode == 200) {
      // debugPrint(
      //     '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${response.body}');
      return PointOfInterest.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
