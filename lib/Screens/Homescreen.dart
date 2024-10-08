import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Model/user_model.dart';
import 'package:chattapplication/Pages/CameraPage.dart';
import 'package:chattapplication/Pages/ChatPage.dart';
import 'package:chattapplication/Pages/StatusPage.dart';
import 'package:flutter/material.dart';
class Homescreen1 extends StatefulWidget {
  const Homescreen1({super.key,this.chatmodels,this.sourcechat,required this.allUsers, this.currentUser});
  final List<ChatModel>? chatmodels;
  final ChatModel? sourcechat;
  final List<UserModel> allUsers;
  final UserModel? currentUser;

  @override
  State<Homescreen1> createState() => _Homescreen1State();
}

class _Homescreen1State extends State<Homescreen1>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RSA Project",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff023E7D), // تعديل اللون الأساسي ل AppBar
        shadowColor: Color(0xff33415C),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("New group"),
                  value: 'New group',
                ),
                PopupMenuItem(
                  child: Text("New broadcast"),
                  value: 'New broadcast',
                ),
                PopupMenuItem(
                  child: Text("Whatsapp web"),
                  value: 'Whatsapp web',
                ),
                PopupMenuItem(
                  child: Text("Starred messages"),
                  value: 'Starred messages',
                ),
                PopupMenuItem(
                  child: Text("Settings"),
                  value: 'Settings',
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraPage(),
          Chatpage(
            chatmodels: widget.chatmodels,
            sourcechat: widget.sourcechat,
            allUsers:widget.allUsers,
            currentUser: widget.currentUser,
          ),
          StatusPage(),
          Text("CALLS"),
        ],
      ),
    );
  }
}
