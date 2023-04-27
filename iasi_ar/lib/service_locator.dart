import 'package:get_it/get_it.dart';
import 'package:iasi_ar/services/image_convertor_service.dart';
import 'package:iasi_ar/services/implementations/base_64_service.dart';
import 'package:iasi_ar/services/implementations/image_api_service.dart';

final GetIt getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<ImageConvertorService>(() => Base64Service());
  getIt.registerLazySingleton<ImageApiService>(() => ImageApiService());
}
