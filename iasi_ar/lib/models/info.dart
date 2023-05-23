import 'package:flutter/material.dart';
import 'package:iasi_ar/services/translator.dart';
import '../service_locator.dart';

class Information {
  String openingHours;
  String info0;
  String info1;
  String info2;
  String info3;
  final _translator = getIt<Translator>();

  Information(
      {required this.openingHours,
      required this.info0,
      required this.info1,
      required this.info2,
      required this.info3});

  Future<Information> getTranslatedInfo(String to) async {
    return Information(
        openingHours: await _translator.translate(openingHours, to),
        info0: await _translator.translate(info0, to),
        info1: await _translator.translate(info1, to),
        info2: await _translator.translate(info2, to),
        info3: await _translator.translate(info3, to));
  }
}
