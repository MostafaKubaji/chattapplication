import 'package:chattapplication/screens/authenticate_screen.dart';
import 'package:chattapplication/screens/register_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Face Authentication",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xff023E7D),
        elevation: 10,
        shadowColor: const Color(0xff33415C),
        centerTitle: true,
      ),
      body: Center(  // تعديل هذا الجزء إلى Center لضمان المحاذاة في الوسط
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,  // لضمان أن جميع العناصر تبقى في الوسط
          children: [
            Image.asset(
              'assets/s1.png',
              height: 150,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Register User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff023E7D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AuthenticateScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.lock_open),
              label: const Text('Authenticate User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff023E7D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
