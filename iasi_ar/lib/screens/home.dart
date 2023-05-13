import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/models/app_language.dart';
import 'package:iasi_ar/provider/app_locale.dart';
import 'package:iasi_ar/screens/camera.dart';
import 'package:iasi_ar/services/image_convertor_service.dart';
import 'package:iasi_ar/services/implementations/image_api_service.dart';
import 'package:iasi_ar/widgets/detector.dart';
import 'package:iasi_ar/widgets/ar.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/explore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../service_locator.dart';

class MyHomePage extends StatefulWidget {
  // List<CameraDescription> cameras;
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImageConvertorService _imageConvertorService =
      getIt<ImageConvertorService>();
  final ImageApiService _imageApiService = getIt<ImageApiService>();
  final _translator = GoogleTranslator();
  var _appLocale;
  late AppLanguage dropdownValue;
  Color borderColor = Colors.transparent;
  String predictedPOI = '';
  PointOfInterest? poi;
  AR? ar = AR();
  // Camera? camera;
  bool exploreButtonVisibility = false;
  bool detectionMode = true;

  @override
  void initState() {
    super.initState();
    // camera = Camera(cameras: widget.cameras);
    dropdownValue = AppLanguage.languages.first;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        ar!,
        // camera!,
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
                onChanged: (AppLanguage? language) {
                  setState(() {
                    dropdownValue = language!;
                    _appLocale.changeLocale(Locale(language.languageCode));
                  });
                })),
        if (detectionMode)
          PoiDetection(
              borderColor: borderColor,
              predictedPOI: predictedPOI,
              exploreButtonVisibility: exploreButtonVisibility,
              onChangeMode: onChangeMode),
        if (!detectionMode)
          Explore(poi: poi, languageCode: _appLocale.locale.languageCode),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onTakeScreenshot,
          backgroundColor: const Color(0xFF232946),
          label: Text(AppLocalizations.of(context)!.discover_button_text),
          foregroundColor: Colors.white),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> onTakeScreenshot() async {
    setState(() {
      detectionMode = true;
      predictedPOI = AppLocalizations.of(context)!.loading_text;
    });
    ImageProvider image = await ar!.arSessionManager!.snapshot();
    _imageConvertorService.imageToBase64(image).then((image64) => {
          _imageApiService.detectPoi(image64).then((response) => {
                poi = response,
                setState(() {
                  borderColor = const Color(0xFF0B6623);
                  exploreButtonVisibility = true;
                }),
                _translator
                    .translate(
                        poi!.name!
                            .split(RegExp(r"(?<=[a-z])(?=[A-Z])"))
                            .join(" "),
                        from: 'en',
                        to: _appLocale.locale.languageCode)
                    .then((value) => {
                          setState(() {
                            predictedPOI = value.text;
                          })
                        })
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
}
