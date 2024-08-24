import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key, this.message, this.time, this.path, this.key1});
  
  final String? message;
  final String? time;
  final String? path;
  final String? key1;

  // تغيير اسم الـ getter لتجنب التداخل
  String get messageWithKey => 'Key is: $key1';

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
          color: Color(0xff1e6091),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5),
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
                  message ?? '', // هنا استخدم message بدون تعارض
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 162, 169, 188),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: Color.fromARGB(255, 139, 161, 204),
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
