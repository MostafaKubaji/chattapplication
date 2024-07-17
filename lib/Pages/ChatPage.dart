import 'package:chattapplication/CustomUI/CustomCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/SelectContact.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  List<ChatModel> chats = [
    ChatModel(
        name: 'mostafa',
        isGroup: false,
        currentMessage: 'hi mostafa',
        time: "4:00",
        icon: 'person.svg'),
    ChatModel(
        name: 'Ahmad',
        isGroup: false,
        currentMessage: 'hi Ahmad',
        time: "5:00",
        icon: 'person.svg'),
    ChatModel(
        name: 'group idleb',
        isGroup: true,
        currentMessage: 'hi everyone on this group',
        time: "8:00",
        icon: 'groups.svg'),
    ChatModel(
        name: 'Ali',
        isGroup: false,
        currentMessage: 'hi Ali',
        time: "8:00",
        icon: 'person.svg'),
    ChatModel(
        name: 'group Halap',
        isGroup: true,
        currentMessage: 'hi everyone on this group',
        time: "0:00",
        icon: 'groups.svg'),
    ChatModel(
        name: 'Sara',
        isGroup: false,
        currentMessage: 'call me in 2:00',
        time: "8:30",
        icon: 'person.svg'),
    ChatModel(
        name: 'OctoTech',
        isGroup: true,
        currentMessage: 'welcome to this group ',
        time: "8:33",
        icon: 'groups.svg'),
    ChatModel(
        name: 'OctoTech2',
        isGroup: true,
        currentMessage: 'welcome to this group ',
        time: "8:33",
        icon: 'groups.svg'),
            ChatModel(
        name: 'OctoTech3',
        isGroup: true,
        currentMessage: 'welcome to this group ',
        time: "8:33",
        icon: 'groups.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Selectcontact(),
            ),
          );
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
          
        ),
        backgroundColor: Color(0xff128c7e),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) => Customcard(
          chatModel: chats[index],
        ),
      ),
    );
  }
}
