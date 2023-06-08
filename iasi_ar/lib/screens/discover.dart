import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iasi_ar/models/app_language.dart';
import 'package:iasi_ar/services/implementations/image_api_service.dart';
import 'package:iasi_ar/widgets/detector.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/explore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../service_locator.dart';
import '../services/translator.dart';

class DiscoverPage extends StatefulWidget {
  final CameraDescription camera;
  final AppLanguage language;
  const DiscoverPage({super.key, required this.camera, required this.language});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _imageApiService = getIt<ImageApiService>();
  final _translator = getIt<Translator>();
  FlutterTts flutterTts = FlutterTts();
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  Color borderColor = Colors.transparent;
  String predictedPOI = '';
  PointOfInterest? poi;
  bool exploreButtonVisibility = false;
  bool detectionMode = true;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.high,
        enableAudio: false);
    _initializeControllerFuture = _cameraController.initialize();
    initialiseTextToSpeech();
  }

  Future<void> onTakeScreenshot() async {
    await flutterTts.stop();
    setState(() {
      detectionMode = true;
      predictedPOI = AppLocalizations.of(context)!.loading_text;
      borderColor = Colors.transparent;
      exploreButtonVisibility = false;
    });

    _cameraController.takePicture().then((image) {
      String image64;
      image.readAsBytes().then((bytes) => {
            image64 = base64Encode(bytes),
            _imageApiService.detectPoi(image64).then((response) => {
                  poi = response,
                  setState(() {
                    borderColor = const Color(0xFF0B6623);
                    exploreButtonVisibility = true;
                  }),
                  getPredictedPoiTranslated(
                      poi!.name.split(RegExp(r"(?<=[a-z])(?=[A-Z])")).join(" "))
                })
          });
    });

    // ImageProvider image = await ar!.arSessionManager!.snapshot();
    // _imageConvertorService.imageToBase64(image).then((image64) => {
    //       _imageApiService.detectPoi(image64).then((response) => {
    //             poi = response,
    //             setState(() {
    //               borderColor = const Color(0xFF0B6623);
    //               exploreButtonVisibility = true;
    //             }),
    //             getPredictedPoiTranslated(
    //                 poi!.name.split(RegExp(r"(?<=[a-z])(?=[A-Z])")).join(" "))
    //           })
    //     });
  }

  void getPredictedPoiTranslated(String text) async {
    _translator.translate(text, widget.language.languageCode).then((text) => {
          setState(() {
            predictedPOI = text;
          })
        });
  }

  void onChangeMode() {
    setState(() {
      detectionMode = false;
      borderColor = Colors.transparent;
      exploreButtonVisibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Transform.scale(
                  scale: 1 /
                      (_cameraController.value.aspectRatio *
                          MediaQuery.of(context).size.aspectRatio),
                  alignment: Alignment.topCenter,
                  child: CameraPreview(_cameraController));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        if (detectionMode) ...[
          PoiDetection(
              borderColor: borderColor,
              predictedPOI: predictedPOI,
              exploreButtonVisibility: exploreButtonVisibility,
              onChangeMode: onChangeMode),
        ],
        if (!detectionMode)
          Explore(
              poi: poi!,
              languageCode: widget.language.languageCode,
              flutterTts: flutterTts),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onTakeScreenshot,
          backgroundColor: const Color(0xFF232946),
          label: Text(AppLocalizations.of(context)!.discover_button_text),
          foregroundColor: Colors.white),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void initialiseTextToSpeech() async {
    await flutterTts.setLanguage(
        '${widget.language.languageCode}-${widget.language.countryCode}');
    await flutterTts.setSpeechRate(widget.language.speechRate);
  }
}
