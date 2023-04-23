import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iasi_ar/models/app_language.dart';
import 'package:iasi_ar/provider/app_locale.dart';
import 'package:iasi_ar/widgets/detector.dart';
import 'package:iasi_ar/widgets/ar.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/explore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

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
  late AppLanguage dropdownValue;
  var _appLocale;
  final _translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
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
        if (!detectionMode) Explore(poi: poi, languageCode: _appLocale.locale.languageCode),
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
    String image64 = await imageToBase64(image);

    var response = await http.post(
        Uri.parse('http://192.168.197.121:8003/image_api'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image64": image64}));

    if (response.statusCode == 200) {
      poi = PointOfInterest.fromJson(jsonDecode(response.body));
      var actualPOI =
          poi!.name!.split(RegExp(r"(?<=[a-z])(?=[A-Z])")).join(" ");
      setState(() {
        borderColor = const Color(0xFF0B6623);
        exploreButtonVisibility = true;
      });
      if (_appLocale.locale.languageCode == 'ro') {
        _translator.translate(actualPOI, from: 'en', to: 'ro').then((value) => {
              setState(() {
                predictedPOI = value.text;
              })
            });
      } else {
        setState(() {
          predictedPOI = actualPOI;
        });
      }
    }
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
