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
      name: 'مصطفى',
      isGroup: false,
      currentMessage: 'hi mostafa',
      time: "4:00",
      icon: 'person.svg',
      id: 1,
    ),
    ChatModel(
      name: 'عمر المرعي',
      isGroup: false,
      currentMessage: 'hi Omar',
      time: "5:00",
      icon: 'person.svg',
      id: 2,
    ),
    ChatModel(
      name: 'محمد سكندر',
      isGroup: false,
      currentMessage: 'hi Mohamed',
      time: "8:00",
      icon: 'person.svg',
      id: 3,
    ),
    ChatModel(
      name: "الأستاذ باسم",
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
                  chatmodels: chatsModels,
                  sourcechat: sourceChat,
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
