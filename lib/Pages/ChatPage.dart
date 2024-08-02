import 'package:chattapplication/CustomUI/CustomCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/SelectContact.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key,this.chatmodels,this.sourcechat});
  final List<ChatModel>? chatmodels;
  final ChatModel? sourcechat;


  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Selectcontact(     
              ),
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
        itemCount: widget.chatmodels?.length,
        itemBuilder: (context, index) => Customcard(
          chatModel: widget.chatmodels![index],
          sourcechat: widget.sourcechat,
        ),
      ),
    );
  }
}
