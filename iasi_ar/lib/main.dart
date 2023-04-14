import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iasi_ar/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inside Iași',
      theme: ThemeData(textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Point of interest detection AR'),
    );
  }
}
