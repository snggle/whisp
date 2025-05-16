import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whisp/page/main_page.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  bool platformWindowsBool = Platform.isWindows;

  if (platformWindowsBool) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(300, 500),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      minimumSize: Size(201, 335),
      maximumSize: Size(399, 665),

    );
    await windowManager.setAspectRatio(0.6);
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(CoreApp(platformWindowsBool: platformWindowsBool));
}

class CoreApp extends StatelessWidget {
  final bool platformWindowsBool;

  const CoreApp({
    required this.platformWindowsBool,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(
        platformWindowsBool: platformWindowsBool,
      ),
    );
  }
}
