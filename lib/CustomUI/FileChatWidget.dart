import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileChatWidget extends StatefulWidget {
  final Function(String base64String, String fileName, String filePath) onFileSend;

  const FileChatWidget({super.key, required this.onFileSend});

  @override
  State<FileChatWidget> createState() => _FileChatWidgetState();
}

class _FileChatWidgetState extends State<FileChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send File'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              File file = File(result.files.single.path!);
              List<int> fileBytes = await file.readAsBytes();
              String base64String = base64Encode(fileBytes);
              widget.onFileSend(base64String, result.files.single.name, file.path);
              Navigator.pop(context);  // Close the widget after sending the file
            }
          },
          child: Text(
            "Pick and Send File",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
