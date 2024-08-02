import 'package:chattapplication/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chattapplication/services/network_handler.dart';
import 'dart:async';
import 'dart:convert';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 164, 190, 238), // Background color
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome to RSA Project",
                style: TextStyle(
                  color: Color(0xff0466C8), // Text color
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              SvgPicture.asset(
                "assets/s1.svg", // Ensure the path is correct
                height: 300,
                width: 300,
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 11),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Color(0xff33415C), // Text color
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: "Agree and Continue to accept the",
                        style: TextStyle(color: Color(0xff7D8597)), // Text color
                      ),
                      TextSpan(
                        text: " RSA Terms of service and privacy policy",
                        style: TextStyle(
                          color: Color(0xff0466C8), // Text color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  print("Button pressed");
                  bool connectionSuccessful = await NetworkHandler.testConnection();
                  print("Connection successful: $connectionSuccessful");
                  
                  // عرض Snackbar للإشارة إلى حالة الاتصال
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(connectionSuccessful 
                          ? "Connection successful!" 
                          : "Failed to connect to the server."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  
                  if (connectionSuccessful) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => LoginScreen()),
                      (route) => false,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Connection Error"),
                          content: Text("Failed to connect to the server. Please try again."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 50,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    color: Color(0xff002855), // Button color
                    child: Center(
                      child: Text(
                        "Agree And Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
