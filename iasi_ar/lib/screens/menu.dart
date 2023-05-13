import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iasi_ar/screens/camera.dart';

import 'home.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF232946),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await availableCameras().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Camera(cameras: value)),
                    );
                  });
                },
                child: const Text("Scan")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ));
                },
                child: const Text("Discover"))
          ],
        ));
  }
}
