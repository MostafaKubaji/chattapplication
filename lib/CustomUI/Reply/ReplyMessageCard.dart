import 'package:flutter/material.dart';

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard({super.key, this.message, this.time, this.path});
  final String? message;
  final String? time;
  final String? path; // إضافة المعامل هنا

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: Color(0xff34a0a4),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 60,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 162, 169, 188),
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