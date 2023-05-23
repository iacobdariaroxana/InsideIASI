import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:iasi_ar/services/recognizer.dart';

class MLRecognizer extends Recognizer {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<String> recognize(InputImage inputImage) async {
    final recognizedObj = await textRecognizer.processImage(inputImage);
    return recognizedObj.text;
  }
}
