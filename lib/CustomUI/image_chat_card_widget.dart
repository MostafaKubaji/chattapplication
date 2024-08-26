import 'dart:convert';
import 'package:flutter/material.dart';

class ImageChatWidget extends StatelessWidget {
  const ImageChatWidget({
    super.key,
    required this.data,
    required this.message,
    required this.time,
  });

  final String data;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height / 2.3,
          width: MediaQuery.of(context).size.width / 1.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 0, 77, 150),
          ),
          child: Card(
            margin: EdgeInsets.all(3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Image.memory(
                  base64Decode(data),
                    fit: BoxFit.fitHeight,            
                  ),
                ),
                // Text(message),
                Text(time),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
