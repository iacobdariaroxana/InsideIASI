import 'package:flutter/material.dart';

abstract class ImageConvertorService {
  Future<String> imageToBase64(ImageProvider imageProvider);
}
