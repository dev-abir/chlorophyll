import 'package:chlorophyll/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/*
WARNING: The tflite library might have some bugs...
goto /home/tom/flutter/.pub-cache/hosted/pub.dartlang.org/tflite-1.1.2/android/build.gradle
and change the apropriate lines to:
dependencies {
    implementation 'org.tensorflow:tensorflow-lite:+'
    implementation 'org.tensorflow:tensorflow-lite-gpu:+'
}
*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chlorophyll',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green, // TODO: no effect
          primaryColor: Colors.green,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.green)),
      // themeMode: ThemeMode.system, // set to system by default
      home: const Home(),
    );
  }
}
