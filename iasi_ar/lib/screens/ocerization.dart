import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:iasi_ar/service_locator.dart';
import 'package:iasi_ar/services/recognizer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../models/language.dart';
import '../services/translator.dart';

class Ocerization extends StatefulWidget {
  const Ocerization({super.key});

  @override
  State<StatefulWidget> createState() => _OcerizationState();
}

class _OcerizationState extends State<Ocerization> {
  final ImagePicker picker = ImagePicker();
  final _translator = getIt<Translator>();
  final _recognizer = getIt<Recognizer>();
  late Language dropdownLanguage;
  String? cropOptionText;
  String? imagePath;
  String text =
      "În Iași se află una dintre cele mai importante universități din România, Universitatea 'Alexandru Ioan Cuza' din Iași, fondată în anul 1860.";

  @override
  void initState() {
    super.initState();
    dropdownLanguage = Language.languages.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cropOptionText = AppLocalizations.of(context)!.crop_option_text;
  }

  void takePicture() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      cropImage(image);
    }
  }

  void cropImage(XFile image) async {
    CroppedFile? cropped = await ImageCropper()
        .cropImage(sourcePath: image.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: cropOptionText!,
          toolbarColor: const Color(0xFFb8c1ec),
          cropGridColor: Colors.transparent,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(title: 'Crop', showCancelConfirmationDialog: true)
    ]);
    if (cropped != null) {
      recognizeText(cropped.path);
      setState(() {
        imagePath = cropped.path;
      });
    }
  }

  void recognizeText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final recognizedText = await _recognizer.recognize(inputImage);
    setState(() {
      text = recognizedText;
    });
  }

  void openTranslatedText() async {
    await _translator
        .translate(text, dropdownLanguage.languageCode)
        .then((translation) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  scrollable: true,
                  backgroundColor: const Color(0xFFb8c1ec),
                  content: Text(translation),
                  // actions: [
                  //   IconButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       icon: const Icon(
                  //         Icons.close,
                  //         color: Color(0xFF121629),
                  //       ))
                  // ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121629),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: imagePath != null
                ? Image.file(File(imagePath!))
                : Image.asset('assets/images/iasi.png'),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton(
                    menuMaxHeight: 150,
                    iconSize: 20,
                    value: dropdownLanguage,
                    items: Language.languages
                        .map<DropdownMenuItem<Language>>(
                          (e) => DropdownMenuItem<Language>(
                              alignment: AlignmentDirectional.center,
                              value: e,
                              child: Text(
                                e.flagIcon,
                                style: const TextStyle(fontSize: 20.0),
                              )),
                        )
                        .toList(),
                    onChanged: (Language? language) {
                      setState(() {
                        dropdownLanguage = language!;
                      });
                    }),
                CircleAvatar(
                    backgroundColor: const Color.fromARGB(200, 238, 187, 195),
                    child: IconButton(
                        onPressed: openTranslatedText,
                        icon: const Icon(
                          Icons.translate,
                          color: Colors.white,
                        )))
              ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        backgroundColor: const Color.fromARGB(200, 238, 187, 195),
        child: const Icon(
          Icons.document_scanner,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
