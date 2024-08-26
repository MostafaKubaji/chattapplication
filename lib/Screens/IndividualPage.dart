import 'dart:convert';
import 'dart:io';
//5
import 'package:chattapplication/CustomUI/Own/OwnFileDisplay.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyFileDisplay.dart';
import 'package:chattapplication/CustomUI/Own/OwnImageCard.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyImageCard.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyMessageCard.dart';
import 'package:chattapplication/CustomUI/image_chat_card_widget.dart';
import 'package:chattapplication/CustomUI/FileChatWidget.dart';
import 'package:chattapplication/Screens/CameraScreen.dart';
import 'package:chattapplication/Screens/CameraView.dart';
import 'package:flutter/material.dart';
import 'package:chattapplication/CustomUI/Own/OwnMessageCard.dart';
import 'package:chattapplication/Model/MessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:chattapplication/CustomUI/FileChatWidget.dart' as chat;
import 'package:chattapplication/CustomUI/Reply/ReplyFileDisplay.dart'
    as display;
import 'package:encrypt/encrypt.dart' as encrypt;

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, this.chatModel, this.sourceChat});
  final ChatModel? chatModel;
  final ChatModel? sourceChat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ImagePicker _picker = ImagePicker();
  FocusNode focusNode = FocusNode();
  List<MessageModel> messages = [];
  bool showEmojiPicker = false;
  bool sendButton = false;
  IO.Socket? socket;
  XFile? file;
  int popTime = 0;

  // مفتاح التشفير بطول 128 بت (16 بايت)
  final key = encrypt.Key.fromUtf8('my16byteskey1234'); // 16 بايت
  final iv = encrypt.IV.fromLength(16); // Initialization Vector

  // دالة التشفير مع حفظ الـ IV مع الرسالة
  String encryptMessage(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${encrypted.base16}:${iv.base16}'; // حفظ الرسالة المشفرة مع الـ IV
  }

  // دالة فك التشفير باستخدام الـ IV المحفوظ مع الرسالة
  String decryptMessage(String encryptedTextWithIv) {
    final parts = encryptedTextWithIv.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid encrypted text format');
    }
    final encryptedText = parts[0];
    final iv = encrypt.IV.fromBase16(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted =
        encrypter.decrypt(encrypt.Encrypted.fromBase16(encryptedText), iv: iv);
    return decrypted;
  }

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
      socket = IO.io("http://192.168.84.119:5000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket?.connect();
      socket?.onConnect((data) {
        print("Connected to the server");
        socket?.emit("signin", widget.sourceChat?.id);

        // التأكد من عدم تكرار المستمع
        socket?.off("message");

        socket?.on("message", (msg) {
          print("New message received: ${msg["message"]}");
          if (msg["message"] != null) {
            String decryptedMessage = decryptMessage(msg["message"]);
            print("Decrypted message: $decryptedMessage");
            setMessage(
              "destination",
              decryptedMessage,
              msg["path"] ?? '',
              isImage: msg["isImage"] == true,
              isFile: msg["isFile"] == true,
            );
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            print("Received message without content");
          }
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

  void sendMessage(String message, int? sourceId, int? targetId, String path,
      {bool isImage = false, bool isFile = false}) {
    if (sourceId == null || targetId == null || message.isEmpty) {
      print("Error: sourceId, targetId, or message is null or empty");
      return;
    }

    // تشفير الرسالة قبل الإرسال
    String encryptedMessage = encryptMessage(message);

    print("Sending message from $sourceId to $targetId: $encryptedMessage");

    socket?.emit(
      "message",
      {
        "message": encryptedMessage, // إرسال الرسالة المشفرة
        "sourceId": sourceId,
        "targetId": targetId,
        "isImage": isImage,
        "isFile": isFile,
        "path": path,
      },
    );

    // إضافة الرسالة غير المشفرة إلى القائمة عند المرسل
    setMessage("source", message, path, isImage: isImage, isFile: isFile);
    print("Message sent and added to source list: $message");
  }

  void setMessage(String type, String message, String path,
      {bool? isImage = false, bool? isFile = false}) {
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      path: path,
      isImage: isImage,
      isFile: isFile,
      time: DateTime.now().toString().substring(10, 16),
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  void onSendImage(
    String type,
    File image,
    String path,
  ) async {
    final imageBytes = await image.readAsBytes();

    final imageBase64String = base64Encode(imageBytes);

    sendMessage(
        imageBase64String, widget.sourceChat?.id, widget.chatModel?.id, "",
        isImage: true);
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
                // child: buildMessagesList(),

                child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length + 1,
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return SizedBox(height: 70);
                }
                final message = messages[index];

                String getFileType(String? path) {
                  if (path == null || path.isEmpty) return 'unknown';
                  final extension = path.split('.').last.toLowerCase();
                  switch (extension) {
                    case 'pdf':
                      return 'pdf';
                    case 'doc':
                    case 'docx':
                      return 'doc';
                    default:
                      return 'unknown';
                  }
                }

                if (message.isFile == true) {
                  return OwnFileDisplay(
                    filePath: message.path ?? '',
                    time: message.time ?? '',
                    fileType: getFileType(message.path),
                  );
                } else if (message.isImage == true) {
                  return ImageChatWidget(
                    data: message.message ?? '',
                    message: message.message ?? '',
                    time: message.time ?? '',
                  );
                } else if (message.type == "source") {
                  if (message.path != null && message.path!.isNotEmpty) {
                    return OwnImageCard(
                      path: message.path ?? '',
                      message: message.message ?? '',
                      time: message.time ?? '',
                    );
                  } else {
                    return OwnMessageCard(
                      message: message.message,
                      time: message.time,
                    );
                  }
                } else {
                  if (message.path != null && message.path!.isNotEmpty) {
                    return ReplyImageCard(
                      path: message.path ?? '',
                      message: message.message ?? '',
                      time: message.time ?? '',
                    );
                  } else {
                    return ReplyMessageCard(
                      message: message.message,
                      time: message.time,
                      path: message.path,
                    );
                  }
                }
              },
            )),
            buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildImagePreview(),
            buildMessageInput(),
            buildEmojiPicker(),
          ],
        ),
      ),
    );
  }

  Widget buildImagePreview() {
    return file != null
        ? Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
            ),
            child: Image.file(File(file!.path)),
          )
        : SizedBox();
  }

  Widget buildMessageInput() {
    return Row(
      children: [
        buildMessageField(),
        buildSendButton(),
      ],
    );
  }

  Widget buildMessageField() {
    return Flexible(
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
            if (value.isNotEmpty) {
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
            suffixIcon: buildAttachmentIcons(),
            contentPadding: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }

  Widget buildAttachmentIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.attach_file),
          onPressed: () {
            showAttachmentOptions();
          },
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () async {
            setState(() {
              popTime = 2;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => CameraScreen(
                  onImageSend: onSendImage,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildSendButton() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        right: 5,
        left: 2,
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Color(0xff128C7E),
        child: IconButton(
          icon: Icon(
            sendButton ? Icons.send : Icons.mic,
            color: Colors.white,
          ),
          onPressed: () {
            if (sendButton) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
              sendMessage(
                _controller.text.trim(),
                widget.sourceChat?.id,
                widget.chatModel?.id,
                "",
              );
              _controller.clear();
              setState(() {
                sendButton = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget buildEmojiPicker() {
    return showEmojiPicker
        ? SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
                setState(() {
                  sendButton = true;
                });
              },
            ),
          )
        : SizedBox.shrink();
  }

  void showAttachmentOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => buildBottomSheet(),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: Column(
            children: [
              buildBottomSheetRow(
                [
                  buildBottomSheetOption(
                    icon: Icons.insert_drive_file,
                    color: Colors.indigo,
                    label: "Document",
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileChatWidget(
                            onFileSend: (String base64String, String fileName,
                                String filePath, String fileType) {
                              // هنا يمكنك تنفيذ ما تريد فعله مع الملف الذي تم إرساله
                              print("File sent: $fileName");
                              // استخدم الدالة sendMessage لإرسال الملف
                              sendMessage(
                                base64String, // المحتوى المشفر للملف
                                widget.sourceChat?.id,
                                widget.chatModel?.id,
                                filePath,
                                isFile: true,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  buildBottomSheetOption(
                    icon: Icons.camera_alt,
                    color: Colors.pink,
                    label: "Camera",
                    onPressed: () async {
                      setState(() {
                        popTime = 3;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CameraScreen(
                            onImageSend: onSendImage,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  buildBottomSheetOption(
                    icon: Icons.insert_photo,
                    color: Colors.purple,
                    label: "Gallery",
                    onPressed: () async {
                      setState(() {
                        popTime = 2;
                      });
                      file =
                          await _picker.pickImage(source: ImageSource.gallery);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CameraViewPage(
                            path: file!.path,
                            onImageSend: onSendImage,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              buildBottomSheetRow(
                [
                  buildBottomSheetOption(
                    icon: Icons.headset,
                    color: Colors.orange,
                    label: "Audio",
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  buildBottomSheetOption(
                    icon: Icons.location_pin,
                    color: Colors.teal,
                    label: "Location",
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  buildBottomSheetOption(
                    icon: Icons.person,
                    color: Colors.blue,
                    label: "Contact",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheetRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget buildBottomSheetOption({
    required IconData icon,
    required Color color,
    required String label,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
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
          Text(label),
        ],
      ),
    );
  }
}
