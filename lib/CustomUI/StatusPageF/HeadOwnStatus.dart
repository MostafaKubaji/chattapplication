import 'package:flutter/material.dart';

class HeadOwnStatus extends StatelessWidget {
  const HeadOwnStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xff5C677D), // لون من المجموعة المقدمة
            backgroundImage: AssetImage("assets/m1.png"),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Color(0xff0466C8), // لون من المجموعة المقدمة
              radius: 10,
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      title: Text(
        "My Status",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff023E7D), // لون من المجموعة المقدمة
        ),
      ),
      subtitle: Text(
        "Tap to add status update",
        style: TextStyle(
          fontSize: 13,
          color: Color(0xff7D8597), // لون من المجموعة المقدمة
        ),
      ),
    );
  }
}
