import 'package:camera/camera.dart';
import 'package:chattapplication/Screens/CameraScreen.dart';
import 'package:chattapplication/Screens/Homescreen.dart';
import 'package:flutter/material.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras=await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: Color(0xff075e54),
        appBarTheme: AppBarTheme(
          color: Color(0xff128c7e),
        ),
      ),
      home:Homescreen(),
      
    );
  }
}
