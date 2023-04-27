import 'package:translator/translator.dart';

class Information {
  String openingHours;
  String info0;
  String info1;
  String info2;
  String info3;
  final _translator = GoogleTranslator();

  Information(
      {required this.openingHours,
      required this.info0,
      required this.info1,
      required this.info2,
      required this.info3});

  Future<Information> getTranslatedInfo(String to) async {
    return Information(
        openingHours: await translate(openingHours, to),
        info0: await translate(info0, to),
        info1: await translate(info1, to),
        info2: await translate(info2, to),
        info3: await translate(info3, to));
  }

  Future<String> translate(value, to) async {
    var translation = await _translator.translate(value, to: to);
    return translation.text;
  }
}
