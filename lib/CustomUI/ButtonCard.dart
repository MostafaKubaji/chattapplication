import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, this.name, this.icon});
  final String? name;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(
          icon,
          color: Color(0xffFFFFFF), // لون الأيقونة
        ),
        backgroundColor: Color(0xff0466C8), // لون خلفية الدائرة
      ),
      title: Text(
        name ?? '',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xff023E7D), // لون النص
        ),
      ),
    );
  }
}
