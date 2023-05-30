import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/screens/ocerization.dart';
import 'package:provider/provider.dart';
import '../models/app_language.dart';
import '../provider/app_locale.dart';
import 'discover.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State<Menu> {
  var _appLocale;
  late AppLanguage dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = AppLanguage.languages.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appLocale = Provider.of<AppLocale>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/monuments.png'),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [
                Positioned(
                    right: 20,
                    top: 30,
                    child: DropdownButton(
                        iconSize: 10,
                        value: dropdownValue,
                        items: AppLanguage.languages
                            .map<DropdownMenuItem<AppLanguage>>(
                              (e) => DropdownMenuItem<AppLanguage>(
                                  alignment: AlignmentDirectional.center,
                                  value: e,
                                  child: Text(
                                    e.flagIcon,
                                    style: const TextStyle(fontSize: 20.0),
                                  )),
                            )
                            .toList(),
                        onChanged: (AppLanguage? language) async {
                          setState(() {
                            dropdownValue = language!;
                            _appLocale
                                .changeLocale(Locale(language.languageCode));
                          });
                        })),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await availableCameras().then((cameras) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiscoverPage(
                                        camera: cameras.first,
                                        language: dropdownValue,
                                      ),
                                    ));
                              });
                            },
                            icon: const Icon(
                              Icons.explore_outlined,
                              size: 55,
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Ocerization()),
                            );
                          },
                          icon: const Icon(
                            Icons.document_scanner,
                            size: 50,
                          ),
                        )
                      ]),
                )
              ],
            )));
  }
}
