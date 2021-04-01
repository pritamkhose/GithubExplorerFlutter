import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../constant.dart' as Constants;

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share', icon: Icons.share),
  const Choice(title: 'Exit', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

class Utility {
  // https://stackoverflow.com/questions/49356664/how-to-override-the-back-button-in-flutter
  Future<bool> onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // https://pub.dev/packages/flutter_custom_tabs
  void launchURL(BuildContext context, html_url) async {
    try {
      await launch(
        html_url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation.slideIn()
          /* or user defined animation.
          animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
          )*/
          ,
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      // debugPrint(e.toString());
      print('No CustomTabs --> ' + e.toString());
      _launchURLBrower(context, html_url);
    }
  }

  // https://pub.dev/packages/url_launcher
  _launchURLBrower(BuildContext context, String url) async {
    if (await url_launcher.canLaunch(url)) {
      await launch(url);
    } else {
      // throw 'Could not launch $url';
      final snackBar = SnackBar(
        content: Text('Invalid URL = ' + url),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // https://pub.dev/packages/share
  void shareURL(BuildContext context, String shareURL) {
    // Share.share('check out my website https://example.com');
    final RenderBox box = context.findRenderObject();
    Share.share(Constants.GitHubURL + shareURL,
        subject: 'Share ' + shareURL + ' Link!',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
