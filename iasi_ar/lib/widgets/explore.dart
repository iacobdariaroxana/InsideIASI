import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class Explore extends StatefulWidget {
  final PointOfInterest? poi;

  const Explore({super.key, this.poi});
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<String> poiOptions = ['Program', 'Infos', 'Interior', 'Site'];
  Widget selectedOptionWidget = Container();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 20.0,
            right: 20.0,
            top: 40.0,
            child: SizedBox(height: 100,child: 
            ListView.separated(
                // shrinkWrap: true,
                separatorBuilder: (context, index) => const Divider(indent: 6,),
                scrollDirection: Axis.horizontal,
                itemCount: poiOptions.length,
                itemBuilder: (context, index) => createCard(index)))),
        Align(
          alignment: Alignment.center,
          child: selectedOptionWidget,
        )
      ],
    );
  }

  Widget createCard(int index) {
    return ElevatedButton(
        onPressed: () => handleExploreOptionPressed(index),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            minimumSize: const Size(80, 80),
            backgroundColor: const Color(0xFF232946)),
        child: Text(
          poiOptions[index],
          style: const TextStyle(fontSize: 9.5),
        ));
  }

  void handleExploreOptionPressed(int index) {
    setState(() {
      selectedOptionWidget = mapIndexToWidget(index);
    });
  }

  Widget getProgramWidget() {
    return DefaultTextStyle(
        style: const TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        child: AnimatedTextKit(animatedTexts: [
          TypewriterAnimatedText(widget.poi!.openingHours!,
              speed: const Duration(milliseconds: 60))
        ]));
  }

  Widget getInfosWidget() {
    return SizedBox(
        width: 200.0,
        // height: 00.0,
        child: DefaultTextStyle(
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(widget.poi!.info0!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(widget.poi!.info1!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(widget.poi!.info2!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(widget.poi!.info3!,
                    speed: const Duration(milliseconds: 60))
              ],
              pause: const Duration(milliseconds: 3000),
              stopPauseOnTap: true,
            )));
  }

  Widget getInteriorWidget() {
    debugPrint('${widget.poi!.name}.mp4');
    return SizedBox(
        width: 350, child: Video(videoUrl: '${widget.poi!.name}.mp4'));
  }

  Widget getLinkWidget() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          color: const Color(0xffeebbc3)),
      child: InkWell(
          onTap: () => launchUrl(Uri.parse(widget.poi!.link!)),
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              'Visit us!',
              style: TextStyle(
                  height: 1.0,
                  letterSpacing: 1.0,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )),
    );
  }

  Widget mapIndexToWidget(int index) {
    switch (index) {
      case 0:
        return getProgramWidget();
      case 1:
        return getInfosWidget();
      case 2:
        return getInteriorWidget();
      case 3:
        return getLinkWidget();
      default:
        return Container();
    }
  }
}
