import 'package:chattapplication/CustomUI/ButtonCard.dart';
import 'package:chattapplication/CustomUI/ContactCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/CreateGroup.dart';
import 'package:flutter/material.dart';

class Selectcontact extends StatefulWidget {
  const Selectcontact({super.key});

  @override
  State<Selectcontact> createState() => _SelectcontactState();
}

class _SelectcontactState extends State<Selectcontact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(name: 'Ali', status: "a full stack developer"),
      ChatModel(name: 'Mostafa', status: 'Flutter developer'),
      ChatModel(name: 'Sara', status: 'C# developer'),
      ChatModel(name: 'OctoTech', status: 'Company OctoTech'),
      ChatModel(name: 'Abdo', status: 'Java developer'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff002855), // Color of the AppBar
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Contact",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "256 Contacts",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
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
                  child: Text("Invite a friend"),
                  value: 'Invite a friend',
                ),
                PopupMenuItem(
                  child: Text("Contacts"),
                  value: 'Contacts',
                ),
                PopupMenuItem(
                  child: Text("Refresh"),
                  value: 'Refresh',
                ),
                PopupMenuItem(
                  child: Text("Help"),
                  value: 'Help',
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => CreateGroup(),
                  ),
                );
              },
              child: ButtonCard(
                
                icon: Icons.group,
                name: "New group",
              ),
            );
          } else if (index == 1) {
            return ButtonCard(
              
              icon: Icons.person_add,
              name: "New contact",
            );
          }
          return ContactCard(contact: contacts[index - 2]);
        },
      ),
    );
  }
}
