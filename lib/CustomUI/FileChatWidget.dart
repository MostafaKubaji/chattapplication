import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chattapplication/CustomUI/Own/OwnFileDisplay.dart';

class FileChatWidget extends StatefulWidget {
  final Function(String base64String, String fileName, String filePath, String fileType) onFileSend;

  const FileChatWidget({super.key, required this.onFileSend});

  @override
  State<FileChatWidget> createState() => _FileChatWidgetState();
}

class _FileChatWidgetState extends State<FileChatWidget> {
  File? selectedFile;
  String? filePath;

  // دالة لفك تشفير Base64 وحفظ الملف
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
                fileType: selectedFile!.path.split('.').last,
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
                  String base64String = base64Encode(fileBytes); // تعديل استخدام base64Encode بدلاً من base64Decode
                  String fileType = selectedFile!.path.split('.').last;

                  // فك التشفير وحفظ الملف
                  String savedFilePath = await decodeAndSaveFile(base64String, selectedFile!.path.split('/').last);

                  if (savedFilePath.isNotEmpty) {
                    // هنا يمكنك استخدام المسار المحفوظ للملف
                    print("File successfully saved and ready to use: $savedFilePath");
                  }

                  widget.onFileSend(base64String, selectedFile!.path.split('/').last, selectedFile!.path, fileType);
                  Navigator.pop(context);
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
