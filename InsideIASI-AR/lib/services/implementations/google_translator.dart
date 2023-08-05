import 'package:iasi_ar/services/translator.dart';
import 'package:translator/translator.dart';

class GoogleApiTranslator extends Translator {
  final _translator = GoogleTranslator();

  @override
  Future<String> translate(String text, String language) async {
    var response = await _translator.translate(text, to: language);
    return response.text;
  }
}
