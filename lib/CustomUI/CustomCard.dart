import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // استيراد الحزمة

class Customcard extends StatelessWidget {
  const Customcard({super.key, required this.chatModel,this.sourcechat });
  final ChatModel chatModel;
  final ChatModel? sourcechat;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Individualpage(
              chatModel: chatModel,
              sourcechat: sourcechat,
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                chatModel.isGroup == true
                    ? "assets/groups.svg"
                    : "assets/person.svg",
                color: Color(0xffFFFFFF), // تحديث لون الأيقونات
                height: 38,
                width: 38,
              ),
              backgroundColor: Color(0xff33415C), // تحديث لون خلفية الدائرة
            ),
            title: Text(
              chatModel.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff023E7D), // تحديث لون النص
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.done_all,
                  color: Color(0xff0466C8), // تحديث لون الأيقونة
                ),
                SizedBox(width: 3),
                Text(
                  chatModel.currentMessage ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7D8597), // تحديث لون النص
                  ),
                ),
              ],
            ),
            trailing: Text(
              chatModel.time ?? '',
              style: TextStyle(
                color: Color(0xff5C677D), // تحديث لون النص
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
              color: Color(0xff001233), // تحديث لون الفاصل
            ),
          ),
        ],
      ),
    );
  }
}
