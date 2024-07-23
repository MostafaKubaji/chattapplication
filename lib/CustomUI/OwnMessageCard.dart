import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xff1e6091), // لون خلفية البطاقة
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
                  'Hey mostafa ajdskajsdl asjdlasjdl akldjsl kajdlkasj sdajd lkasj',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffFFFFFF), // لون النص
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      "20:58",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 162, 169, 188), // لون الوقت
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: Color.fromARGB(255, 139, 161, 204), // لون الأيقونة
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
