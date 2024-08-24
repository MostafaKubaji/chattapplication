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
              FileDisplayWidget(
                filePath: filePath ?? '',
                message: 'Selected File',
                time: TimeOfDay.now().format(context),
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
                    widget.onFileSend(base64String, selectedFile!.path.split('/').last, selectedFile!.path);
                    Navigator.pop(context);  // Close the widget after sending the file
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

class FileDisplayWidget extends StatelessWidget {
  final String filePath;
  final String message;
  final String time;

  const FileDisplayWidget({
    Key? key,
    required this.filePath,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insert_drive_file, size: 30, color: Colors.indigo),
          SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    filePath,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
