import 'package:get_it/get_it.dart';
import 'package:iasi_ar/services/image_convertor_service.dart';
import 'package:iasi_ar/services/implementations/base_64_service.dart';
import 'package:iasi_ar/services/implementations/google_translator.dart';
import 'package:iasi_ar/services/implementations/image_api_service.dart';
import 'package:iasi_ar/services/implementations/ml_recognizer.dart';
import 'package:iasi_ar/services/recognizer.dart';
import 'package:iasi_ar/services/translator.dart';

final GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<ImageConvertorService>(() => Base64Service());
  getIt.registerLazySingleton<ImageApiService>(() => ImageApiService());
  getIt.registerLazySingleton<Translator>(() => GoogleApiTranslator());
  getIt.registerLazySingleton<Recognizer>(() => MLRecognizer());
}
