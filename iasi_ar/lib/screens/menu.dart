// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/screens/ocerization.dart';
import 'discover.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/monuments.png'),
                    fit: BoxFit.cover)),
            // color: const Color(0xFF232946),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      // await availableCameras().then((cameras) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscoverPage(
                                // camera: cameras.first,
                                ),
                          ));
                      // });
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
              ],
            )));
  }
}
