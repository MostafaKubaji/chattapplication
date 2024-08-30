import 'package:chattapplication/CustomUI/CustomCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Model/user_model.dart';
import 'package:chattapplication/Screens/SelectContact.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage(
      {super.key,
      this.chatmodels,
      this.sourcechat,
      required this.allUsers,
      this.currentUser});
  final List<ChatModel>? chatmodels;
  final ChatModel? sourcechat;
  final List<UserModel> allUsers;
  final UserModel? currentUser;

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  List<ChatModel>? _realChats = [];
  @override
  void initState() {
    super.initState();
    _realChats = widget.allUsers
        .where((e) => e.id != widget.currentUser?.id)
        .map(
          (e) => ChatModel(
            name: e.name,
            currentMessage: "hi",
            id: e.id ?? "",
          ),
        )
        .toList();
  }

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
        backgroundColor: Color(0xff0466C8), // Updated color
      ),
      body: ListView.builder(
        itemCount: _realChats?.length,
        itemBuilder: (context, index) => Customcard(
          chatModel: _realChats![index],
          sourcechat: ChatModel(
            name: widget.currentUser?.name,
            currentMessage: "hi",
            id: widget.currentUser?.id ?? "",
          ),
        ),
      ),
    );
  }
}
