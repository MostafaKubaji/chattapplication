import 'package:chattapplication/CustomUI/OwnMessageCard.dart';
import 'package:chattapplication/CustomUI/ReplyMessageCard.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Individualpage extends StatefulWidget {
  const Individualpage({super.key, this.chatModel,this.sourcechat});
  final ChatModel? chatModel;
  final ChatModel? sourcechat;

  @override
  _IndividualpageState createState() => _IndividualpageState();
}

class _IndividualpageState extends State<Individualpage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  IO.Socket? socket;
  TextEditingController _controller = TextEditingController();
  bool sendButton = false;

  @override
  void initState() {
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

void connect() {
  try {
    socket = IO.io("http://192.168.1.102:5000", <String, dynamic>{
      "transports": ["websocket"],
      
      "autoConnect": false,
    });

    socket?.connect();
    socket?.onConnect((_) {
      print("Connected to the server");
      socket?.emit("signin", widget.sourcechat?.id);
    });

    socket?.onConnectError((data) {
      print("Connection Error: $data");
    });

    socket?.onError((error) {
      print("Error: $error");
    });

    socket?.onDisconnect((_) {
      print("Disconnected from the server");
    });
    
    print("Attempting to connect...");
  } catch (e) {
    print("Error during connection: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              backgroundColor: Color(0xff002855),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.white,
                    ),
                    CircleAvatar(
                      child: SvgPicture.asset(
                        widget.chatModel?.isGroup == true
                            ? "assets/groups.svg"
                            : "assets/person.svg",
                        color: Colors.white54,
                        height: 38,
                        width: 38,
                      ),
                      radius: 20,
                      backgroundColor: Color(0xff33415C),
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatModel?.name ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Last seen today at 12:20",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.videocam,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: 'View Contact',
                      ),
                      PopupMenuItem(
                        child: Text("Media, Links, and docs"),
                        value: 'Media, Links, and docs',
                      ),
                      PopupMenuItem(
                        child: Text("Whatsapp web"),
                        value: 'Whatsapp web',
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: 'Search',
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notification"),
                        value: 'Mute Notification',
                      ),
                      PopupMenuItem(
                        child: Text("wallpaper"),
                        value: 'wallpaper',
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 155,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                        OwnMessageCard(),
                        ReplyMessageCard(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Card(
                                margin: EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextFormField(
                                  controller: _controller,
                                  focusNode: focusNode,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (value) {
                                    if (value.length > 0) {
                                      setState(() {
                                        sendButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        sendButton = false;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type a message",
                                    contentPadding: EdgeInsets.all(5),
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.emoji_emotions),
                                      color: Color(0xff0353A4),
                                      onPressed: () {
                                        focusNode.unfocus();
                                        focusNode.canRequestFocus = false;
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) =>
                                                    bottomsheet());
                                          },
                                          icon: Icon(Icons.attach_file),
                                          color: Color(0xff0353A4),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.camera_alt),
                                          color: Color(0xff0353A4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: 8, right: 5, left: 2),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff0353A4),
                                child: IconButton(
                                  icon: Icon(
                                    sendButton ? Icons.send : Icons.mic,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        show ? emojiSelect() : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(
                      Icons.insert_drive_file, Color(0xff023E7D), "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.camera_alt, Color(0xff0466C8), "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                      Icons.insert_photo, Color(0xff001845), "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.headset, Color(0xff001845), "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                      Icons.location_pin, Color(0xff5C677D), "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(Icons.person, Color(0xff7D8597), "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconcreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 29,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
        });
      },
    );
  }
}
