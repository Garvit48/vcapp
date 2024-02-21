import "package:flutter/material.dart";
import "package:vcapp/HomePage.dart";
void main() {
  runApp(App());
}

class App extends StatefulWidget {
  App({super.key});

  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Widget build(BuildContext build) {
    return MaterialApp(
      home: HomePage()
    );
  }
}