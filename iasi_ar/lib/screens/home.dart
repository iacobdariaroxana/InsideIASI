import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iasi_ar/widgets/detector.dart';
import 'package:iasi_ar/widgets/ar.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/explore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color borderColor = Colors.transparent;
  String predictedPOI = '';
  bool exploreButtonVisibility = false;
  bool detectionMode = true;
  PointOfInterest? poi;
  AR? ar = AR();
  List<String> poiOptions = ['Program', 'Infos', 'Images', 'Video'];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ar!,
        if (detectionMode)
          PoiDetection(
              borderColor: borderColor,
              predictedPOI: predictedPOI,
              exploreButtonVisibility: exploreButtonVisibility,
              onChangeMode: onChangeMode),
        if (!detectionMode) Explore(poi: poi),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onTakeScreenshot,
          backgroundColor: const Color(0xFF232946),
          label: const Text("Discover point of interest"),
          foregroundColor: Colors.white),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> onTakeScreenshot() async {
    var start = DateTime.now();
    setState(() {
      detectionMode = true;
      predictedPOI = "Loading...";
    });
    ImageProvider image = await ar!.arSessionManager!.snapshot();
    String image64 = await imageToBase64(image);

    var response = await http.post(
        Uri.parse('http://192.168.224.121:8003/image_api'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image64": image64}));

    if (response.statusCode == 200) {
      poi = PointOfInterest.fromJson(jsonDecode(response.body));
      setState(() {
        borderColor = const Color(0xFF0B6623);
        predictedPOI = poi!.name!;
        exploreButtonVisibility = true;
      });
    }
    var end = DateTime.now();
    debugPrint('${end.difference(start).inSeconds}');
  }

  Future<String> imageToBase64(ImageProvider imageProvider) async {
    var completer = Completer<Uint8List>();
    ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);

    stream.addListener(ImageStreamListener((image, synchronousCall) async {
      ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      completer.complete(bytes!.buffer.asUint8List());
    }));
    Uint8List bytes = await completer.future;
  
    var imageData = base64.encode(bytes);
    return imageData;
  }

  void onChangeMode() {
    setState(() {
      detectionMode = false;
      borderColor = Colors.transparent;
      exploreButtonVisibility = false;
    });
  }
}
