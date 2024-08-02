// import 'package:chattapplication/CustomUI/OwnMessageCard.dart';
// import 'package:chattapplication/CustomUI/ReplyMessageCard.dart';
// import 'package:chattapplication/Model/MessageModel.dart';
// import 'package:chattapplication/Screens/CameraScreen.dart';
// import 'package:chattapplication/Screens/CameraView.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:chattapplication/Model/ChatModel.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;

// class IndividualPage extends StatefulWidget {
//   const IndividualPage({super.key, this.chatModel, this.sourceChat});
//   final ChatModel? chatModel;
//   final ChatModel? sourceChat;

//   @override
//   _IndividualPageState createState() => _IndividualPageState();
// }

// class _IndividualPageState extends State<IndividualPage> {
//   bool showEmojiPicker = false;
//   FocusNode focusNode = FocusNode();
//   IO.Socket? socket;
//   TextEditingController _controller = TextEditingController();
//   bool sendButton = false;
//   List<MessageModel> messages = [];
//   ScrollController _scrollController = ScrollController();
//   ImagePicker _picker = ImagePicker();
//   XFile? file;

//   @override
//   void initState() {
//     super.initState();
//     connect();
//     focusNode.addListener(() {
//       if (focusNode.hasFocus) {
//         setState(() {
//           showEmojiPicker = false;
//         });
//       }
//     });
//   }

// void connect() {
//   try {
//     socket = IO.io(
//         "https://chat-server-theta-five.vercel.app/check", // بدون /check
//         <String, dynamic>{
//           "transports": ["websocket"],
//           "autoConnect": false,
//         });

//     socket?.connect();
//     socket?.onConnect((_) {
//       print("Connected to the server");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Connected to the server'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       socket?.emit("signin", widget.sourceChat?.id);
//       socket?.on("message", (msg) {
//         print("New message: $msg");
//         setMessage(
//           "destination",
//           msg["message"],
//           msg["path"],
//         );
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       });
//     });

//     socket?.onConnectError((data) {
//       print("Connection Error: $data");
//     });

//     socket?.onError((error) {
//       print("Error: $error");
//     });

//     socket?.onDisconnect((_) {
//       print("Disconnected from the server");
//     });

//     print("Attempting to connect...");
//   } catch (e) {
//     print("Error during connection: $e");
//   }
// }

//   void sendMessage(String message, int sourceId, int targetId, String path) {
//     socket?.emit(
//       "message",
//       {
//         "message": message,
//         "sourceId": sourceId,
//         "targetId": targetId,
//         "path": path,
//       },
//     );
//     setMessage("source", message, path);
//   }

//   void setMessage(String type, String message, String path) {
//     MessageModel messageModel = MessageModel(
//       type: type,
//       message: message,
//       path: path,
//       time: DateTime.now().toString().substring(10, 16),
//     );
//     setState(() {
//       messages.add(messageModel);
//     });
//   }

//   void onImageSend(String path) async {
//     try {
//       print("Sending image at path: $path");
//       var request = http.MultipartRequest("POST",
//           Uri.parse("https://chat-server-theta-five.vercel.app/api/addimage"));
//       request.files.add(await http.MultipartFile.fromPath('img', path));
//       request.headers.addAll({
//         "Content-type": "multipart/form-data",
//       });
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         print("Image uploaded successfully!");
//       } else {
//         print("Failed to upload image. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           "assets/background.png",
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.cover,
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: buildAppBar(context),
//           body: buildChatBody(context),
//         ),
//       ],
//     );
//   }

//   PreferredSizeWidget buildAppBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(60),
//       child: AppBar(
//         leadingWidth: 70,
//         titleSpacing: 0,
//         backgroundColor: Color(0xff002855),
//         leading: buildLeading(),
//         title: buildTitle(),
//         actions: buildAppBarActions(),
//       ),
//     );
//   }

//   Widget buildLeading() {
//     return InkWell(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.arrow_back,
//             size: 24,
//             color: Colors.white,
//           ),
//           CircleAvatar(
//             child: SvgPicture.asset(
//               widget.chatModel?.isGroup == true
//                   ? "assets/groups.svg"
//                   : "assets/person.svg",
//               color: Colors.white54,
//               height: 38,
//               width: 38,
//             ),
//             radius: 20,
//             backgroundColor: Color(0xff33415C),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildTitle() {
//     return InkWell(
//       onTap: () {},
//       child: Container(
//         margin: EdgeInsets.all(6),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.chatModel?.name ?? "",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               "Last seen today at 12:20",
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 13,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> buildAppBarActions() {
//     return [
//       IconButton(
//         onPressed: () {},
//         icon: Icon(
//           Icons.videocam,
//           color: Colors.white,
//         ),
//       ),
//       IconButton(
//         onPressed: () {},
//         icon: Icon(
//           Icons.call,
//           color: Colors.white,
//         ),
//       ),
//       PopupMenuButton<String>(
//         icon: Icon(Icons.more_vert, color: Colors.white),
//         onSelected: (value) {
//           print(value);
//         },
//         itemBuilder: (BuildContext context) {
//           return [
//             PopupMenuItem(
//               child: Text("View Contact"),
//               value: 'View Contact',
//             ),
//             PopupMenuItem(
//               child: Text("Media, Links, and docs"),
//               value: 'Media, Links, and docs',
//             ),
//             PopupMenuItem(
//               child: Text("Whatsapp web"),
//               value: 'Whatsapp web',
//             ),
//             PopupMenuItem(
//               child: Text("Search"),
//               value: 'Search',
//             ),
//             PopupMenuItem(
//               child: Text("Mute Notification"),
//               value: 'Mute Notification',
//             ),
//             PopupMenuItem(
//               child: Text("Wallpaper"),
//               value: 'Wallpaper',
//             ),
//           ];
//         },
//       ),
//     ];
//   }

//   Widget buildChatBody(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: WillPopScope(
//         onWillPop: () async {
//           if (showEmojiPicker) {
//             setState(() {
//               showEmojiPicker = false;
//             });
//             return false;
//           } else {
//             return true;
//           }
//         },
//         child: Column(
//           children: [
//             Expanded(
//               child: buildMessagesList(),
//             ),
//             buildInputArea(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildMessagesList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       controller: _scrollController,
//       itemCount: messages.length + 1,
//       itemBuilder: (context, index) {
//         if (index == messages.length) {
//           return Container(
//             height: 70,
//           );
//         }
//         if (messages[index].type == "source") {
//           return OwnMessageCard(
//             message: messages[index].message,
//             time: messages[index].time,
//           );
//         } else {
//           return ReplyMessageCard(
//             message: messages[index].message,
//             time: messages[index].time,
//           );
//         }
//       },
//     );
//   }

//   Widget buildInputArea() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 70,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Row(
//               children: [
//                 buildMessageInputField(),
//                 buildSendButton(),
//               ],
//             ),
//             showEmojiPicker ? buildEmojiPicker() : Container(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildMessageInputField() {
//     return Container(
//       width: MediaQuery.of(context).size.width - 60,
//       child: Card(
//         margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: TextFormField(
//           controller: _controller,
//           focusNode: focusNode,
//           textAlignVertical: TextAlignVertical.center,
//           keyboardType: TextInputType.multiline,
//           onChanged: (value) {
//             if (value.isNotEmpty) {
//               setState(() {
//                 sendButton = true;
//               });
//             } else {
//               setState(() {
//                 sendButton = false;
//               });
//             }
//           },
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             hintText: "Type a message",
//             contentPadding: EdgeInsets.all(5),
//             prefixIcon: IconButton(
//               icon: Icon(Icons.emoji_emotions),
//               color: Color(0xff0353A4),
//               onPressed: () {
//                 focusNode.unfocus();
//                 focusNode.canRequestFocus = false;
//                 setState(() {
//                   showEmojiPicker = !showEmojiPicker;
//                 });
//               },
//             ),
//             suffixIcon: buildSuffixIcons(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildSuffixIcons() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           onPressed: () {
//             showModalBottomSheet(
//                 backgroundColor: Colors.transparent,
//                 context: context,
//                 builder: (builder) => buildBottomSheet());
//           },
//           icon: Icon(Icons.attach_file),
//           color: Color(0xff0353A4),
//         ),
//         IconButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (builder) => CameraScreen(
//                   onImageSend: onImageSend,
//                 ),
//               ),
//             );
//           },
//           icon: Icon(Icons.camera_alt),
//           color: Color(0xff0353A4),
//         ),
//       ],
//     );
//   }

//   Widget buildSendButton() {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8, right: 5, left: 2),
//       child: CircleAvatar(
//         radius: 25,
//         backgroundColor: Color(0xff0353A4),
//         child: IconButton(
//           icon: Icon(
//             sendButton ? Icons.send : Icons.mic,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             if (sendButton) {
//               _scrollController.animateTo(
//                 _scrollController.position.maxScrollExtent,
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeOut,
//               );
//               sendMessage(
//                 _controller.text,
//                 widget.sourceChat?.id ?? 0,
//                 widget.chatModel?.id ?? 0,
//                 "",
//               );
//               _controller.clear();
//               setState(() {
//                 sendButton = false;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildBottomSheet() {
//     return Container(
//       height: 278,
//       width: MediaQuery.of(context).size.width,
//       child: Card(
//         margin: EdgeInsets.all(18),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildIconCreation(Icons.insert_drive_file, Colors.indigo,
//                       "Document", () {}),
//                   SizedBox(width: 40),
//                   buildIconCreation(Icons.camera_alt, Colors.pink, "Camera",
//                       () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (builder) => CameraScreen(
//                           onImageSend: onImageSend,
//                         ),
//                       ),
//                     );
//                   }),
//                   SizedBox(width: 40),
//                   buildIconCreation(
//                       Icons.insert_photo, Colors.purple, "Gallery", () async {
//                     file = await _picker.pickImage(source: ImageSource.gallery);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (builder) => CameraViewPage(
//                           onImageSend: onImageSend,
//                           path: file?.path,
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//               SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildIconCreation(
//                       Icons.headset, Colors.orange, "Audio", () {}),
//                   SizedBox(width: 40),
//                   buildIconCreation(
//                       Icons.location_pin, Colors.teal, "Location", () {}),
//                   SizedBox(width: 40),
//                   buildIconCreation(
//                       Icons.person, Colors.blue, "Contact", () {}),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildIconCreation(
//       IconData icon, Color color, String text, void Function()? onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: color,
//             child: Icon(
//               icon,
//               size: 29,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(height: 5),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: 12,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget buildEmojiPicker() {
//     return EmojiPicker(
//       onEmojiSelected: (category, emoji) {
//         setState(() {
//           _controller.text = _controller.text + emoji.emoji;
//         });
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:chattapplication/CustomUI/OwnMessageCard.dart';
import 'package:chattapplication/CustomUI/ReplyMessageCard.dart';
import 'package:chattapplication/Model/MessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, this.chatModel, this.sourceChat});
  final ChatModel? chatModel;
  final ChatModel? sourceChat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();
  IO.Socket? socket;
  TextEditingController _controller = TextEditingController();
  bool sendButton = false;
  List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  ImagePicker _picker = ImagePicker();
  XFile? file;

  @override
  void initState() {
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  void connect() {
    try {
      socket = IO.io(
          "https://chat-server-theta-five.vercel.app", // بدون /check
          <String, dynamic>{
            "transports": ["websocket"],
            "autoConnect": false,
          });

      socket?.connect();
      socket?.onConnect((_) {
        print("Connected to the server");
        socket?.emit("signin", widget.sourceChat?.id);
        socket?.on("message", (msg) {
          print("New message: $msg");
          setMessage(
            "destination",
            msg["message"],
            msg["path"],
          );
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
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

void sendMessage(String message, int? sourceId, int? targetId, String path) {
  if (sourceId != null && targetId != null) {
    socket?.emit(
      "message",
      {
        "message": message,
        "sourceId": sourceId,
        "targetId": targetId,
        "path": path,
      },
    );
    setMessage("source", message, path);
  } else {
    print("sourceId or targetId is null");
  }
}


  void setMessage(String type, String message, String path) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      path: path,
      time: DateTime.now().toString().substring(10, 16),
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  void onImageSend(String path) async {
    try {
      print("Sending image at path: $path");
      var request = http.MultipartRequest("POST",
          Uri.parse("https://chat-server-theta-five.vercel.app/api/addimage"));
      request.files.add(await http.MultipartFile.fromPath('img', path));
      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("Image uploaded successfully!");
      } else {
        print("Failed to upload image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading image: $e");
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
          appBar: buildAppBar(context),
          body: buildChatBody(context),
        ),
      ],
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        leadingWidth: 70,
        titleSpacing: 0,
        backgroundColor: Color(0xff002855),
        leading: buildLeading(),
        title: buildTitle(),
        actions: buildAppBarActions(),
      ),
    );
  }

  Widget buildLeading() {
    return InkWell(
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
    );
  }

  Widget buildTitle() {
    return InkWell(
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
    );
  }

  List<Widget> buildAppBarActions() {
    return [
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
              child: Text("Wallpaper"),
              value: 'Wallpaper',
            ),
          ];
        },
      ),
    ];
  }

  Widget buildChatBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: WillPopScope(
        onWillPop: () async {
          if (showEmojiPicker) {
            setState(() {
              showEmojiPicker = false;
            });
            return false;
          } else {
            return true;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: buildMessagesList(),
            ),
            buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget buildMessagesList() {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return Container(
            height: 70,
          );
        }
        if (messages[index].type == "source") {
          return OwnMessageCard(
            message: messages[index].message,
            path: messages[index].path,
          );
        } else {
          return ReplyMessageCard(
            message: messages[index].message,
            path: messages[index].path,
          );
        }
      },
    );
  }

  Widget buildInputArea() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildMessageInput(),
              buildSendButton(),
            ],
          ),
          showEmojiPicker ? buildEmojiPicker() : Container(),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextFormField(
          controller: _controller,
          focusNode: focusNode,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          onChanged: (value) {
            setState(() {
              sendButton = value.length > 0;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Type a message",
            prefixIcon: IconButton(
              icon: Icon(Icons.emoji_emotions),
              onPressed: () {
                focusNode.unfocus();
                focusNode.canRequestFocus = false;
                setState(() {
                  showEmojiPicker = !showEmojiPicker;
                });
              },
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) => buildBottomSheet(),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    file = await _picker.pickImage(source: ImageSource.camera);
                    if (file != null) {
                      onImageSend(file!.path);
                    }
                  },
                ),
              ],
            ),
            contentPadding: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xff002855),
        child: IconButton(
          icon: Icon(
            sendButton ? Icons.send : Icons.mic,
            color: Colors.white,
          ),
          onPressed: () {
            if (sendButton) {
              sendMessage(
                _controller.text,
                widget.sourceChat!.id,
                widget.chatModel!.id,
                "",
              );
              _controller.clear();
              setState(() {
                sendButton = false;
              });
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          _controller.text = _controller.text + emoji.emoji;
        },
      ),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      height: 278,
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
                  buildBottomSheetIcon(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(width: 40),
                  buildBottomSheetIcon(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(width: 40),
                  buildBottomSheetIcon(
                      Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildBottomSheetIcon(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(width: 40),
                  buildBottomSheetIcon(
                      Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(width: 40),
                  buildBottomSheetIcon(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheetIcon(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
