import 'package:chattapplication/CustomUI/ButtonCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/Homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chatsModels = [
    ChatModel(
      name: 'mostafa',
      isGroup: false,
      currentMessage: 'hi mostafa',
      time: "4:00",
      icon: 'person.svg',
      id: 1,
    ),
    ChatModel(
      name: 'Ahmad',
      isGroup: false,
      currentMessage: 'hi Ahmad',
      time: "5:00",
      icon: 'person.svg',
      id: 2,
    ),
    ChatModel(
      name: 'Ali',
      isGroup: false,
      currentMessage: 'hi Ali',
      time: "8:00",
      icon: 'person.svg',
      id: 3,
    ),
    ChatModel(
      name: 'Sara',
      isGroup: false,
      currentMessage: 'call me in 2:00',
      time: "8:30",
      icon: 'person.svg',
      id: 4,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatsModels.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            sourceChat = chatsModels.removeAt(index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (builder) => Homescreen(
                  chatmodels:chatsModels,
                  sourcechat:sourceChat ,
                ),
              ),
            );
          },
          child: ButtonCard(
            name: chatsModels[index].name,
            icon: Icons.person,
          ),
        ),
      ),
    );
  }
}
