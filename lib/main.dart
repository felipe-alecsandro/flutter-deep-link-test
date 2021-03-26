import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:app_installer/app_installer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String> installedApps;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getApp() async {
    Map<String, String> _installedApps;

    if (Platform.isAndroid) {
      bool isApp;

      try {
        await AppAvailability.isAppEnabled("br.com.duratex.app_vendedor");
        isApp = true;
      } catch (e) {
        isApp = false;
      }

      if (isApp) {
        _installedApps = await AppAvailability.checkAvailability(
            "br.com.duratex.app_vendedor");
        print('temmmm');
      } else {
        AppInstaller.goStore("br.com.duratex.clickduratex", "123456789");
        print('não tem');
      }
    }

    // setState(() {
    //   installedApps = _installedApps;
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (installedApps == null) getApp();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin flutter_appavailability app'),
        ),
        body: Container(
          margin: EdgeInsets.all(25),
          child: RaisedButton(
            onPressed: () {
              AppAvailability.launchApp(installedApps["package_name"])
                  .then((_) {
                print("App ${installedApps["app_name"]} launched!");
              }).catchError((err) {
                print(err);
              });
            },
            child: const Text('Get Long Link'),
          ),
        ),
      ),
    );
  }
}
