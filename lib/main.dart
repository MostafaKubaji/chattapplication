import 'package:camera/camera.dart';
import 'package:chattapplication/Screens/CameraScreen.dart';
import 'package:chattapplication/Screens/Homescreen.dart';
import 'package:chattapplication/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

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
        primaryColor: Color(0xff002855), // تغيير اللون الأساسي
        appBarTheme: AppBarTheme(
          color: Color(0xff023E7D), // تغيير لون شريط التطبيق
        ),
      ),
      home: LoginScreen(),
    );
  }
}
