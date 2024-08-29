import 'package:camera/camera.dart';
import 'package:chattapplication/Screens/LandingScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';


List<CameraDescription>? cameras;
//888

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: Color(0xff002855),
        appBarTheme: AppBarTheme(
          color: Color(0xff023E7D),
        ),
      ),
      home: LandingScreen(),
    );
  }
  
}
