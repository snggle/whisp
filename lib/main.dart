import 'package:whisp/page/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreApp());
}

class CoreApp extends StatelessWidget {
  const CoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black12,
          selectionHandleColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
