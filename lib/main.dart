import 'package:flutter/material.dart';
// https://stackoverflow.com/questions/64917744/cannot-run-with-sound-null-safety-because-dependencies-dont-support-null-safety
import 'package:splashscreen/splashscreen.dart';

import 'package:github_explorer_flutter/ui/homeapp.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashApp(),
    ));

// https://pub.dev/packages/splashscreen#-example-tab-
// https://stackoverflow.com/questions/43879103/adding-a-splash-screen-to-flutter-apps
class SplashApp extends StatefulWidget {
  const SplashApp({Key? key}) : super(key: key);

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const HomeApp(),
      title: const Text(
        'Github Explorer',
        style: TextStyle(
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
            color: Colors.white),
      ),
//      image: new Image.network('https://flutter.io/images/catalog-widget-placeholder.png'),
//      image: new Image.asset('assets/images/ic_launcher.png'),
      gradientBackground: const LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: const TextStyle(),
      photoSize: 100.0,
//      onClick: () => print("Flutter onClick"),
      loaderColor: Colors.white,
    );
  }
}

