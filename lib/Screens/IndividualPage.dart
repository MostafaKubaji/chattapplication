import 'dart:convert';
import 'dart:io';
//101010
import 'package:chattapplication/CustomUI/Own/OwnFileDisplay.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyFileDisplay.dart';
import 'package:chattapplication/CustomUI/Own/OwnImageCard.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyImageCard.dart';
import 'package:chattapplication/CustomUI/Reply/ReplyMessageCard.dart';
import 'package:chattapplication/CustomUI/image_chat_card_widget.dart';
import 'package:chattapplication/CustomUI/FileChatWidget.dart';
import 'package:chattapplication/Screens/CameraScreen.dart';
import 'package:chattapplication/Screens/CameraView.dart';
import 'package:chattapplication/config.dart';
import 'package:flutter/material.dart';
import 'package:chattapplication/CustomUI/Own/OwnMessageCard.dart';
import 'package:chattapplication/Model/MessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:file_picker/file_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:asn1lib/asn1lib.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' as flutterWidgets;
import 'package:pointycastle/api.dart' as pointycastleAPI;
import 'package:no_screenshot/no_screenshot.dart';

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
  RSAPrivateKey? privateKey;
  RSAPublicKey? targetPublicKey; // إضافة هذا السطر
  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    // secureScreen();
    disableScreenshot();
    listenForScreenshot();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          showEmojiPicker = false;
        });
      }
    });
  }

  void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  void listenForScreenshot() {
    _noScreenshot.screenshotStream.listen((value) {
      print('Screenshot taken: ${value.wasScreenshotTaken}');
      print('Screenshot path: ${value.screenshotPath}');
    });
  }

// void secureScreen() async {
//   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
// }
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair(
      {int bitLength = 2048}) {
    var rnd = SecureRandom('Fortuna')
      ..seed(KeyParameter(Uint8List.fromList(
          List.generate(32, (_) => Random.secure().nextInt(255)))));
    var keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          rnd));

    // الحصول على الزوج العام والخاص
    var pair = keyGen.generateKeyPair();

    // استخراج المفتاح العام والخاص وتحويلهما إلى النوع الصحيح
    var rsaPublicKey = pair.publicKey as RSAPublicKey;
    var rsaPrivateKey = pair.privateKey as RSAPrivateKey;

    // إرجاع الزوج بالمفاتيح الصحيحة
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        rsaPublicKey, rsaPrivateKey);
  }

  Uint8List rsaEncrypt(RSAPublicKey publicKey, Uint8List dataToEncrypt) {
    var encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(RSAPrivateKey privateKey, Uint8List cipherText) {
    var decryptor = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    int inputOffset = 0;
    int inputBlockSize = engine.inputBlockSize;
    int outputBlockSize = engine.outputBlockSize;
    Uint8List output = Uint8List(0);

    while (inputOffset < input.length) {
      int chunkSize = min(inputBlockSize, input.length - inputOffset);
      Uint8List chunk = Uint8List.view(input.buffer, inputOffset, chunkSize);
      Uint8List processedChunk = engine.process(chunk);
      output = Uint8List.fromList(output + processedChunk);
      inputOffset += chunkSize;
    }
    return output;
  }

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

  void connect() {
    try {
      socket = IO.io("$serverIP", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
         "query": {"id": widget.sourceChat?.id},
      });
      socket?.connect();

      socket?.onConnect((data) {
        print("Connected to the server");

        var rsaKeyPair = generateRSAKeyPair();
        var publicKey = rsaKeyPair.publicKey;
        privateKey = rsaKeyPair.privateKey;

        // إرسال المفتاح العام للخادم
        var publicKeyBytes = ASN1Sequence()
          ..add(ASN1Integer(publicKey.modulus!))
          ..add(ASN1Integer(publicKey.exponent!));
        socket?.emit("send_public_key", publicKeyBytes.encodedBytes);

        // إرسال معرف المحادثة للتسجيل
        socket?.emit("signin", widget.sourceChat?.id);
      });

      socket?.on("public_key", (data) {
        print("Received public key data: $data");

        try {
          var asn1Parser = ASN1Parser(Uint8List.fromList(data));
          var sequence = asn1Parser.nextObject() as ASN1Sequence;
          var modulus = sequence.elements[0] as ASN1Integer;
          var exponent = sequence.elements[1] as ASN1Integer;
          targetPublicKey = RSAPublicKey(
              modulus.valueAsBigInteger, exponent.valueAsBigInteger);

          print("Target public key successfully parsed and stored.");
        } catch (e) {
          print("Failed to parse the public key: $e");
        }
      });

      socket?.on("message", (msg) {
        var encryptedAesKeyData = msg['encryptedAesKey'];
        if (encryptedAesKeyData != null) {
          var encryptedAesKey = Uint8List.fromList(encryptedAesKeyData);
          var decryptedAesKey = rsaDecrypt(privateKey!, encryptedAesKey);

          // فك تشفير الرسالة باستخدام مفتاح AES المفكوك
          var encryptedMessage = msg['message'];
          if (encryptedMessage != null && encryptedMessage is String) {
            var decryptedMessage = decryptMessage(encryptedMessage);
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
        } else {
          // التعامل مع الرسالة بدون مفتاح AES مشفر
          var encryptedMessage = msg['message'];
          if (encryptedMessage != null && encryptedMessage is String) {
            var decryptedMessage = decryptMessage(encryptedMessage);
            print("Decrypted message without AES key: $decryptedMessage");

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
        }
      });
    } catch (e) {
      print("Error during connection: $e");
    }
  }

  void sendMessage(String message, String? sourceId, String? targetId, String path,
      {bool isImage = false, bool isFile = false}) {
    // if (sourceId == null || targetId == null || message.isEmpty) {
    //   print("Error: sourceId, targetId, or message is null or empty");
    //   return;
    // }

    // تشفير الرسالة باستخدام AES
    String encryptedMessage = encryptMessage(message);

    if (targetPublicKey == null) {
      // إذا لم يكن هناك مفتاح عام للطرف الآخر، إرسال الرسالة بدون تشفير مفتاح AES
      
      socket?.emit(
        "message",
        {
          "message": encryptedMessage,
          "sourceId": widget.sourceChat?.id,
          "targetId": targetId,
          "isImage": isImage,
          "isFile": isFile,
          "path": path,
          "encryptedAesKey": key.bytes, // إرسال مفتاح AES بدون تشفير
        },
      );
    } else {
      // إذا كان هناك مفتاح عام للطرف الآخر، استخدم التشفير RSA و AES
      Uint8List encryptedAesKey = rsaEncrypt(targetPublicKey!, key.bytes);

      // إرسال الرسالة المشفرة مع مفتاح AES المشفر
      socket?.emit(
        "message",
        {
          "message": encryptedMessage,
          "sourceId": sourceId,
          "targetId": targetId,
          "isImage": isImage,
          "isFile": isFile,
          "path": path,
          "encryptedAesKey": encryptedAesKey,
        },
      );
    }

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
    isMine: false,
    time: DateTime.now().toString().substring(10, 16),
  );

  setState(() {
    messages.add(messageModel);
  });

  // إذا كانت الرسالة من نوع "destination" (أي تم استلامها من الخادم)
  if (type == "destination" && isFile == true) {
    decodeAndSaveFile(message, path.split('/').last).then((filePath) {
      if (filePath.isNotEmpty) {
        setState(() {
          // تحديث المسار المحفوظ للملف في الرسالة
          messageModel.path = filePath;
        });
      }
    });
  }
}



Future<String> decodeAndSaveFile(String base64String, String fileName) async {
  try {
    // فك تشفير السلسلة Base64 إلى بيانات بايت
    List<int> fileBytes = base64Decode(base64String);

    // تحديد المسار الذي سيتم فيه حفظ الملف
    final directory = await Directory.systemTemp.createTemp(); // حفظ الملف في مسار مؤقت
    String filePath = '${directory.path}/$fileName';

    // إنشاء وحفظ الملف
    File file = File(filePath);
    await file.writeAsBytes(fileBytes);

    print('File saved at: $filePath');
    return filePath;
  } catch (e) {
    print('Error decoding and saving file: $e');
    return '';
  }
}



  Future<void> saveDecryptedMessageToFile(String decryptedMessage) async {
    final directory = await Directory.systemTemp.createTemp();
    final file = File('${directory.path}/message.txt');

    await file.writeAsString(decryptedMessage);

    print('Decrypted message saved to ${file.path}');
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

  void onSendFile(String type, File file, String path) async {
    final fileBytes = await file.readAsBytes();
    final fileBase64String = base64Encode(fileBytes);

    sendMessage(
      fileBase64String,
      widget.sourceChat?.id,
      widget.chatModel?.id,
      path,
      isFile: true,
    );
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
                    if (message.type == "source") {
                      return OwnFileDisplay(
                        filePath: message.path ?? '',
                        time: message.time ?? '',
                        fileType: getFileType(message.path),
                      );
                    } else {
                      return ReplyFileDisplay(
                        filePath: message.path ?? '',
                        time: message.time ?? '',
                        fileType: getFileType(message.path),
                      );
                    }
                  } else if (message.isImage == true) {
                    // final isMine=message.
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: message.isMine?MainAxisAlignment.start:MainAxisAlignment.end,
                      children: [
                        ImageChatWidget(
                          data: message.message ?? '',
                          message: message.message ?? '',
                          time: message.time ?? '',
                        ),
                      ],
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
              ),
            ),
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
            // buildImagePreview(),
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
    return flutterWidgets.Padding(
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
        child: flutterWidgets.Padding(
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
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                      if (result != null) {
                        File selectedFile = File(result.files.single.path!);
                        String filePath = result.files.single.path!;
                        String fileType = filePath.split('.').last;

                        // استخدام onSendFile لإرسال الملف
                        onSendFile(fileType, selectedFile, filePath);
                      }
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
                      ).then((value) {
                        Navigator.pop(context);
                        setState(() {});
                      });
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
