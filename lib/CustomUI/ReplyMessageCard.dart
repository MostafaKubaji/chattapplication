import 'package:flutter/material.dart';

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard({super.key});

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
          color: Color(0xff34a0a4), // لون خلفية البطاقة
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
                  'Hey akldjsl kkasj sdajd',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffFFFFFF), // لون النص
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  "20:58",
                  style: TextStyle(
                    fontSize: 13,
                        color: Color.fromARGB(255, 162, 169, 188), // لون الوقت
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
