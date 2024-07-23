import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({super.key, this.contact});
  final ChatModel? contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: SvgPicture.asset(
                  "assets/person.svg",
                  color: Color(0xffFFFFFF), // لون الأيقونات
                  height: 40,
                  width: 40,
                ),
                backgroundColor: Color(0xff33415C), // لون خلفية الدائرة
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Color(0xff001233), // لون خلفية الدائرة الصغيرة
                  radius: 11,
                  child: Icon(
                    Icons.clear,
                    color: Color(0xffFFFFFF), // لون الأيقونة
                    size: 14,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 2,),
          Text(
            contact?.name ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xff7D8597), // لون النص
            ),
          ),
        ],
      ),
    );
  }
}
