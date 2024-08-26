import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chattapplication/CustomUI/Own/OwnFileDisplay.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FileChatWidget extends StatefulWidget {
  final Function(String base64String, String fileName, String filePath, String fileType) onFileSend;

  const FileChatWidget({super.key, required this.onFileSend});

  @override
  State<FileChatWidget> createState() => _FileChatWidgetState();
}

class _FileChatWidgetState extends State<FileChatWidget> {
  File? selectedFile;
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send File'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedFile != null)
              OwnFileDisplay(
                filePath: filePath ?? '',
                time: TimeOfDay.now().format(context),
                fileType: selectedFile!.path.split('.').last, // استخدم نوع الملف الفعلي
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    selectedFile = File(result.files.single.path!);
                    filePath = result.files.single.path!;
                  });
                }
              },
              child: Text(
                selectedFile == null ? "Pick Document" : "Change Document",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            if (selectedFile != null)
              SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedFile != null) {
                  List<int> fileBytes = await selectedFile!.readAsBytes();
                  String base64String = base64Encode(fileBytes);
                  String fileType = selectedFile!.path.split('.').last;
                  widget.onFileSend(base64String, selectedFile!.path.split('/').last, selectedFile!.path, fileType);
                  Navigator.pop(context);  // إغلاق الشاشة بعد إرسال الملف
                }
              },
              child: Text(
                "Send File",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
