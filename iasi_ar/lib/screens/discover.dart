import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iasi_ar/models/app_language.dart';
import 'package:iasi_ar/provider/app_locale.dart';
import 'package:iasi_ar/services/image_convertor_service.dart';
import 'package:iasi_ar/services/implementations/image_api_service.dart';
import 'package:iasi_ar/widgets/detector.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/explore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../service_locator.dart';
import '../services/translator.dart';
import '../widgets/ar.dart';

class DiscoverPage extends StatefulWidget {
  // final CameraDescription camera;
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _imageConvertorService = getIt<ImageConvertorService>();
  final _imageApiService = getIt<ImageApiService>();
  final _translator = getIt<Translator>();
  var _appLocale;
  late AppLanguage dropdownValue;
  FlutterTts flutterTts = FlutterTts();
  // late CameraController _cameraController;
  // late Future<void> _initializeControllerFuture;

  Color borderColor = Colors.transparent;
  String predictedPOI = '';
  PointOfInterest? poi;
  AR? ar;
  bool exploreButtonVisibility = false;
  bool detectionMode = true;

  @override
  void initState() {
    super.initState();
    dropdownValue = AppLanguage.languages.first;
    // _cameraController = CameraController(widget.camera, ResolutionPreset.high,
    //     enableAudio: false);
    // _initializeControllerFuture = _cameraController.initialize();
    ar = AR();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLocale = Provider.of<AppLocale>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onTakeScreenshot() async {
    await flutterTts.stop();
    setState(() {
      detectionMode = true;
      predictedPOI = AppLocalizations.of(context)!.loading_text;
      borderColor = Colors.transparent;
      exploreButtonVisibility = false;
    });

    // _cameraController.takePicture().then((image) {
    //   String image64;
    //   image.readAsBytes().then((bytes) => {
    //         image64 = base64Encode(bytes),
    //         _imageApiService.detectPoi(image64).then((response) => {
    //               poi = response,
    //               setState(() {
    //                 borderColor = const Color(0xFF0B6623);
    //                 exploreButtonVisibility = true;
    //               }),
    //               getPredictedPoiTranslated(
    //                   poi!.name.split(RegExp(r"(?<=[a-z])(?=[A-Z])")).join(" "))
    //             })
    //       });
    // });

    ImageProvider image = await ar!.arSessionManager!.snapshot();
    _imageConvertorService.imageToBase64(image).then((image64) => {
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
  }

  void getPredictedPoiTranslated(String text) async {
    _translator.translate(text, _appLocale.locale.languageCode).then((text) => {
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
        ar!,
        // FutureBuilder<void>(
        //   future: _initializeControllerFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       return Transform.scale(
        //           scale: 1 /
        //               (_cameraController.value.aspectRatio *
        //                   MediaQuery.of(context).size.aspectRatio),
        //           alignment: Alignment.topCenter,
        //           child: CameraPreview(_cameraController));
        //     } else {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
        // Positioned(
        //     right: 15,
        //     bottom: 15,
        //     child: IconButton(
        //       icon: const Icon(Icons.document_scanner),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => const Ocerization()),
        //         );
        //       },
        //     )),
        if (detectionMode) ...[
          PoiDetection(
              borderColor: borderColor,
              predictedPOI: predictedPOI,
              exploreButtonVisibility: exploreButtonVisibility,
              onChangeMode: onChangeMode),
          Positioned(
              left: 10,
              bottom: 15,
              child: DropdownButton(
                  iconSize: 10,
                  value: dropdownValue,
                  items: AppLanguage.languages
                      .map<DropdownMenuItem<AppLanguage>>(
                        (e) => DropdownMenuItem<AppLanguage>(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Text(
                              e.flagIcon,
                              style: const TextStyle(fontSize: 20.0),
                            )),
                      )
                      .toList(),
                  onChanged: (AppLanguage? language) async {
                    await flutterTts.setLanguage(
                        '${language!.languageCode}-${language.countryCode}');
                    await flutterTts.setSpeechRate(language.speechRate);
                    setState(() {
                      dropdownValue = language;
                      _appLocale.changeLocale(Locale(language.languageCode));
                    });
                    getPredictedPoiTranslated(predictedPOI);
                  }))
        ],
        if (!detectionMode)
          Explore(
              poi: poi,
              languageCode: _appLocale.locale.languageCode,
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
}
