import 'package:chattapplication/CustomUI/AvatarCard.dart';
import 'package:chattapplication/CustomUI/ContactCard.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(name: 'Ali', status: "a full stack developer"),
    ChatModel(name: 'Mostafa', status: 'Flutter developer'),
    ChatModel(name: 'Sara', status: 'C# developer'),
    ChatModel(name: 'OctoTech', status: 'Company OctoTech'),
    ChatModel(name: 'Abdo', status: 'Java developer'),
    ChatModel(name: 'Ali2', status: "a full stack developer"),
    ChatModel(name: 'Mostafa2', status: 'Flutter developer'),
    ChatModel(name: 'Sara2', status: 'C# developer'),
    ChatModel(name: 'OctoTech2', status: 'Company OctoTech'),
    ChatModel(name: 'Abdo2', status: 'Java developer'),
  ];
  List<ChatModel> groupMember = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff002855), // لون خلفية شريط التطبيق
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Add participants",
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
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(
                    () {
                      if (contacts[index].select == true) {
                        groupMember.remove(contacts[index]);
                        contacts[index].select = false;
                      } else {
                        groupMember.add(contacts[index]);
                        contacts[index].select = true;
                      }
                    },
                  );
                },
                child: ContactCard(
                  contact: contacts[index],
                ),
              );
            },
          ),
          Column(
            children: [
              Container(
                height: 75,
                color: Color(0xfff1f1f1), // لون خلفية منطقة الأعضاء المحددين
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    if (contacts[index].select == true) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            groupMember.remove(contacts[index]);
                            contacts[index].select = false;
                          });
                        },
                        child: AvatarCard(
                          contact: contacts[index],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Divider(
                thickness: 1.2,
                height: 0,
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
