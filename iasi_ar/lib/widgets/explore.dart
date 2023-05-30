import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/video_player.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/info.dart';

class Explore extends StatefulWidget {
  final PointOfInterest poi;
  final String languageCode;
  final FlutterTts flutterTts;

  const Explore(
      {super.key,
      required this.poi,
      required this.languageCode,
      required this.flutterTts});
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<String> poiOptions = [];
  Widget selectedOptionWidget = Container();
  bool show = false;
  Information? info;
  bool startVoice = true;
  bool showWidgets = false;

  @override
  void dispose() async {
    super.dispose();
    await widget.flutterTts.stop();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    poiOptions = [
      AppLocalizations.of(context)!.explore_option_program,
      AppLocalizations.of(context)!.explore_option_info,
      AppLocalizations.of(context)!.explore_option_video,
      AppLocalizations.of(context)!.explore_option_site,
    ];
    Information(
            openingHours: formatOpeningHours(),
            info0: widget.poi.info0,
            info1: widget.poi.info1,
            info2: widget.poi.info2,
            info3: widget.poi.info3)
        .getTranslatedInfo(widget.languageCode)
        .then((value) {
      info = value;
      setState(() {
        showWidgets = true;
      });
    });
  }

  String formatOpeningHours() {
    var index = widget.poi.openingHours.indexWhere((element) =>
        element.day!.trim() == DateFormat('EEEE').format(DateTime.now()));
    var openingHours = widget.poi.openingHours.sublist(index) +
        widget.poi.openingHours.sublist(0, index);
    String formattedString = openingHours
        .map((e) => e.openingTime!.contains(RegExp(r'\d'))
            ? "${e.day} ${e.openingTime} - ${e.closingTime}"
            : "${e.day} ${e.openingTime}")
        .join("\n");
    return formattedString;
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

  void handleExploreOptionPressed(int index) async {
    await widget.flutterTts.stop();
    setState(() {
      selectedOptionWidget = mapIndexToWidget(index);
    });
  }

  Widget getProgramWidget() {
    // var openingHours = formatOpeningHours();
    startTextToSpeech(info!.openingHours);
    return DefaultTextStyle(
        style: const TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(info!.openingHours,
                speed: const Duration(milliseconds: 90))
          ],
          pause: const Duration(milliseconds: 3000),
          // displayFullTextOnTap: true,
        ));
  }

  Widget getInfosWidget() {
    startTextToSpeech(info!.info0);
    startVoice = true;
    return SizedBox(
        width: 200.0,
        child: DefaultTextStyle(
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(info!.info0,
                      speed: const Duration(milliseconds: 60)),
                  TypewriterAnimatedText(info!.info1,
                      speed: const Duration(milliseconds: 60)),
                  TypewriterAnimatedText(info!.info2,
                      speed: const Duration(milliseconds: 60)),
                  TypewriterAnimatedText(info!.info3,
                      speed: const Duration(milliseconds: 60))
                ],
                pause: const Duration(milliseconds: 2000),
                stopPauseOnTap: true,
                // displayFullTextOnTap: true,
                onNext: (index, loop) {
                  if (loop) {
                    startVoice = false;
                  }
                  if (startVoice) {
                    return startTextToSpeech(mapIndexToText(index));
                  }
                })));
  }

  Widget getInteriorWidget() {
    return SizedBox(
        width: 350, child: Video(videoUrl: 'videos/${widget.poi.name}.mp4'));
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
          onTap: () => launchUrl(Uri.parse(widget.poi.link),
              mode: LaunchMode.externalApplication),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.visit_poi_link_button,
              style: const TextStyle(
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

  void startTextToSpeech(String text) async {
    await widget.flutterTts.speak(text);
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

  String mapIndexToText(int index) {
    switch (index) {
      case 0:
        return info!.info1;
      case 1:
        return info!.info2;
      case 2:
        return info!.info3;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showWidgets) ...[
          Positioned(
              left: 20.0,
              right: 20.0,
              top: 40.0,
              child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                            indent: 6,
                          ),
                      scrollDirection: Axis.horizontal,
                      itemCount: poiOptions.length,
                      itemBuilder: (context, index) => createCard(index)))),
          Align(
            alignment: Alignment.center,
            child: selectedOptionWidget,
          )
        ]
      ],
    );
  }
}
