import 'dart:convert';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ReplyFileDisplay extends StatelessWidget {
  final String filePath;
  final String time;
  final String fileType;

  const ReplyFileDisplay({
    Key? key,
    required this.filePath,
    required this.time,
    required this.fileType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        final filePyte= base64Decode(filePath);
        final path=await getApplicationCacheDirectory();
        File file=File("$path/file.pdf",);
        file=await file.writeAsBytes(filePyte);

        OpenFile.open(file.path); // فتح الملف عند الضغط عليه
      },
      child:Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          child: Container(
            height: MediaQuery.of(context).size.height/9.5,
            width: MediaQuery.of(context).size.width/1.4,

            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 77, 150),
              borderRadius: BorderRadius.circular(10), // زوايا دائرية
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildFileIcon(fileType), // استدعاء الدالة التي تبني أيقونة الملف
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       "file", // عرض اسم الملف فقط
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        time,
                        style: TextStyle(fontSize: 14, color:  Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة تقوم بتحديد الأيقونة المناسبة بناءً على نوع الملف
  Widget _buildFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf, size: 40, color: Colors.red);
      case 'doc':
      case 'docx':
        return Icon(Icons.description, size: 40, color: Colors.blue);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icon(Icons.image, size: 40, color: Colors.green);
      default:
        return Icon(Icons.insert_drive_file, size: 40, color: Colors.indigo);
    }
  }
}
