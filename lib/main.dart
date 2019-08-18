import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:github_explorer_flutter/ui/homeapp.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashApp(),
    ));

// https://pub.dev/packages/splashscreen#-example-tab-
// https://stackoverflow.com/questions/43879103/adding-a-splash-screen-to-flutter-apps
class SplashApp extends StatefulWidget {
  @override
  _SplashAppState createState() => new _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new HomeApp(),
      title: new Text(
        'Github Explorer',
        style: new TextStyle(
            fontFamily: 'DancingScript',
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
            color: Colors.white),
      ),
//      image: new Image.network('https://flutter.io/images/catalog-widget-placeholder.png'),
//      image: new Image.asset('assets/images/ic_launcher.png'),
      gradientBackground: new LinearGradient(
          colors: [Colors.cyan, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
//      onClick: () => print("Flutter onClick"),
      loaderColor: Colors.white,
    );
  }
}

