import 'package:chattapplication/Screens/home_authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                        style:
                            TextStyle(color: Color(0xff7D8597)), // Text color
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

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => HomeScreen()),
                    (route) => false,
                  );
                  // عرض Snackbar للإشارة إلى حالة الاتصال
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
