import 'dart:convert';
import 'package:iasi_ar/models/poi.dart';
import 'package:http/http.dart' as http;

class ImageApiService {
  String url = 'https://inside-iasi.azurewebsites.net/ImagePredictions';
  // String url = 'http://192.168.146.121:8003/image_api';
  Future<PointOfInterest?> detectPoi(String image64) async {
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image64": image64}));
    if (response.statusCode == 200) {
      return PointOfInterest.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
