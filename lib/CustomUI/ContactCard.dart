import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactCard extends StatefulWidget {
  const ContactCard({super.key, this.contact});
  final ChatModel? contact;

  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 55,
        width: 50,
        child: Stack(
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
            isSelected
                ? Positioned(
                    bottom: 4,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Color(0xff0466C8), // لون الخلفية عند تحديد العنصر
                      radius: 11,
                      child: Icon(
                        Icons.check,
                        color: Color(0xffFFFFFF), // لون الأيقونة
                        size: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      title: Text(
        widget.contact?.name ?? '',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xff023E7D), // لون النص
        ),
      ),
      subtitle: Text(
        widget.contact?.status ?? '',
        style: TextStyle(
          fontSize: 13,
          color: Color(0xff7D8597), // لون النص
        ),
      ),
    );
  }
}
