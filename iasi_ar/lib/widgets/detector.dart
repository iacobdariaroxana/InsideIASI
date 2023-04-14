import 'package:flutter/material.dart';

class PoiDetection extends StatefulWidget {
  Color? borderColor;
  String? predictedPOI;
  bool? exploreButtonVisibility;
  final void Function()? onChangeMode;

  PoiDetection(
      {super.key,
      this.borderColor,
      this.predictedPOI,
      this.exploreButtonVisibility,
      this.onChangeMode});
  @override
  State<StatefulWidget> createState() => _PoiDetectionState();
}

class _PoiDetectionState extends State<PoiDetection> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          left: 10.0,
          right: 10.0,
          top: 50.0,
          bottom: 70.0,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: widget.borderColor!, width: 3.0),
              ),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Text(widget.predictedPOI!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          background: Paint()
                            ..strokeWidth = 30.0
                            ..color = const Color(0xffb8c1ec)
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round,
                          letterSpacing: 1.0),
                      textAlign: TextAlign.center)))),
      if (widget.exploreButtonVisibility!)
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: widget.onChangeMode,
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  minimumSize: const Size(120, 120),
                  backgroundColor: const Color(0xFF232946)),
              child:
                  const Text("Explore", style: TextStyle(letterSpacing: 1.0)),
            )),
    ]);
  }
}
