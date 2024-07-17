import 'package:chattapplication/Pages/CameraPage.dart';
import 'package:chattapplication/Pages/ChatPage.dart';
import 'package:flutter/material.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
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
        title: Text("Whatsapp"),
        shadowColor: Color(0xff128c7e),
        
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected:(value){
              print(value);

            } ,
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
          unselectedLabelColor: Colors.white,
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
          Chatpage(),
          Text("STATUS"),
          Text("CALLS"),
        ],
      ),
    );
  }
}
