import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/IndividualPage.dart';
import 'package:chattapplication/Services/network_handler.dart' as services_network_handler;
import 'package:chattapplication/services/network_handler.dart' as other_network_handler;

class Customcard extends StatelessWidget {
  const Customcard({super.key, required this.chatModel, this.sourcechat});
  final ChatModel chatModel;
  final ChatModel? sourcechat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // تحقق من الاتصال بالخادم
        bool isConnected = await services_network_handler.NetworkHandler.testConnection(); // Use alias here

        if (isConnected) {
          // عرض رسالة نجاح عند الاتصال بالخادم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connected to the server'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndividualPage(
                chatModel: chatModel,
                sourceChat: sourcechat,
              ),
            ),
          );
        } else {
          // عرض رسالة فشل عند عدم الاتصال بالخادم
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect to the server. Please try again later.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
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
                color: Color(0xffFFFFFF),
                height: 38,
                width: 38,
              ),
              backgroundColor: Color(0xff33415C),
            ),
            title: Text(
              chatModel.name ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff023E7D),
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.done_all,
                  color: Color(0xff0466C8),
                ),
                SizedBox(width: 3),
                Text(
                  chatModel.currentMessage ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7D8597),
                  ),
                ),
              ],
            ),
            trailing: Text(
              chatModel.time ?? '',
              style: TextStyle(
                color: Color(0xff5C677D),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
              color: Color(0xff001233),
            ),
          ),
        ],
      ),
    );
  }
}
