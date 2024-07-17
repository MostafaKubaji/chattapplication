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
      // onTap: () {
      //   setState(() {
      //     isSelected = !isSelected;
      //   });
      // },
      leading: Container(
        height: 55,
        width: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                "assets/person.svg",
                color: Colors.white,
                height: 40,
                width: 40,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            isSelected
                ? Positioned(
                    bottom: 4,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 11,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
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
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        widget.contact?.status ?? '',
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
