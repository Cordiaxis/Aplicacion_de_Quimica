import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:quimica/screen/aufbau.dart';
import 'package:quimica/screen/buscador.dart';
import 'package:quimica/screen/creditos.dart';
import 'package:quimica/tools/elemento.dart';
import 'package:quimica/tools/globals.dart';
import 'package:quimica/json/leer_json.dart';
import 'package:quimica/screen/tabla_periodica.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) => MaterialApp(
        title: 'Química',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: FlutterSplashScreen.gif(
          gifPath: 'assets/logosc.gif',
          gifWidth: 269,
          gifHeight: 474,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          nextScreen: const MainPage(),
          duration: const Duration(milliseconds: 3400),
          onInit: () async {
            debugPrint("onInit");
          },
          onEnd: () async {
            debugPrint("onEnd 1");
          },
        ),
      ),
    );
  }
}
