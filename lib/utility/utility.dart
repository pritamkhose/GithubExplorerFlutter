import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../constant.dart' as constants;

const List<Choice> choices = <Choice>[
  Choice(title: 'Share', icon: Icons.share),
  Choice(title: 'Exit', icon: Icons.exit_to_app),
];

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class Utility {
  // https://stackoverflow.com/questions/49356664/how-to-override-the-back-button-in-flutter
  showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // https://pub.dev/packages/flutter_custom_tabs
  void launchURL(BuildContext context, htmlURL) async {
    try {
      await launch(
        htmlURL,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          // animation: CustomTabsAnimation.slideIn(),
          // animation: CustomTabsAnimation(
          //   startEnter: 'slide_up',
          //   startExit: 'android:anim/fade_out',
          //   endEnter: 'android:anim/fade_in',
          //   endExit: 'slide_down',
          // ),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
      // print('No CustomTabs --> ' + e.toString());
      _launchURLBrower(context, htmlURL);
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
    Share.share(constants.GitHubURL + shareURL,
        subject: 'Share ' + shareURL + " Link!");
  }
}
