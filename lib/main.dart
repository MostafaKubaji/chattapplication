import 'package:camera/camera.dart';
import 'package:chattapplication/NewScreen/LandingScreen.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;
//100
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
