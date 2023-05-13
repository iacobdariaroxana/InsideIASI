import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/services/image_convertor_service.dart';

class Base64Service extends ImageConvertorService {
  @override
  Future<String> imageToBase64(ImageProvider imageProvider) async {
    var completer = Completer<Uint8List>();

    ImageStream stream =
        imageProvider.resolve(const ImageConfiguration(size: Size(256, 341)));

    stream.addListener(ImageStreamListener((image, synchronousCall) async {
      ByteData? bytes =
          await image.image.toByteData(format: ImageByteFormat.png);
      completer.complete(bytes!.buffer.asUint8List());
    }));
    Uint8List bytes = await completer.future;
    // final WriteBuffer allBytes = WriteBuffer();
    // for (final Plane plane in cameraImage.planes) {
    //   allBytes.putUint8List(plane.bytes);
    // }

    // final bytes = allBytes.done().buffer.asUint8List();

    return base64Encode(bytes);
  }
}
