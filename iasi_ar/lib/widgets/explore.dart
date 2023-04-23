import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/models/poi.dart';
import 'package:iasi_ar/widgets/video_player.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Explore extends StatefulWidget {
  final PointOfInterest? poi;
  final String? languageCode;

  const Explore({super.key, this.poi, this.languageCode});
  @override
  State<StatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<String> poiOptions = [];
  Widget selectedOptionWidget = Container();
  bool show = false;
  String? openingHours;
  String? info0;
  String? info1;
  String? info2;
  String? info3;
  final _translator = GoogleTranslator();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    poiOptions = [
      AppLocalizations.of(context)!.explore_option_program,
      AppLocalizations.of(context)!.explore_option_info,
      AppLocalizations.of(context)!.explore_option_video,
      AppLocalizations.of(context)!.explore_option_site,
    ];
    
    translate(widget.poi!.openingHours!, setOpeningHours);
    translate(widget.poi!.info0!, setInfo0);
    translate(widget.poi!.info1!, setInfo1);
    translate(widget.poi!.info2!, setInfo2);
    translate(widget.poi!.info3!, setInfo3);
  }

  void translate(value, function) {
    _translator
        .translate(value, to: widget.languageCode!)
        .then((value) => function(value.text));
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
          TypewriterAnimatedText(openingHours!,
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
                TypewriterAnimatedText(info0!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(info1!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(info2!,
                    speed: const Duration(milliseconds: 60)),
                TypewriterAnimatedText(info3!,
                    speed: const Duration(milliseconds: 60))
              ],
              pause: const Duration(milliseconds: 3000),
              stopPauseOnTap: true,
            )));
  }

  Widget getInteriorWidget() {
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
          onTap: () => launchUrl(Uri.parse(widget.poi!.link!),
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

  setOpeningHours(String hours) {
    openingHours = hours;
  }

  setInfo0(String info) {
    info0 = info;
  }

  setInfo1(String info) {
    info1 = info;
  }

  setInfo2(String info) {
    info2 = info;
  }

  setInfo3(String info) {
    info3 = info;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
      ],
    );
  }
}
