import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  Camera({super.key, required this.cameras});

  @override
  State<StatefulWidget> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController cameraController;
  CameraImage? cameraImage;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameraController = CameraController(
        widget.cameras[0], ResolutionPreset.high,
        enableAudio: false);
    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((image) {
          cameraImage = image;
        });
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void prepareImage() async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage!.width.toDouble(), cameraImage!.height.toDouble());

    final InputImageRotation? imageRotation =
        InputImageRotationValue.fromRawValue(
            widget.cameras[0].sensorOrientation);

    final InputImageFormat? inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage!.format.raw);

    final planeData = cameraImage!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final String text = block.text;

      for (TextLine line in block.lines) {
        debugPrint(line.text);
        // Same getters as TextBlock
        // for (TextElement element in line.elements) {
        //   debugPrint('${element.text}');
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: CameraPreview(cameraController),
          ),
          // Transform.scale(
          //     scale: 1 /
          //         (cameraController.value.aspectRatio *
          //             MediaQuery.of(context).size.aspectRatio),
          //     alignment: Alignment.topCenter,
          //     child: CameraPreview(cameraController)),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: prepareImage, child: const Text("scan")))
        ]),
      );
    } else {
      return Container();
    }
  }
}
