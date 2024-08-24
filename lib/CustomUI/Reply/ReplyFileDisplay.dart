import 'package:flutter/material.dart';

class ReplyFileDisplay extends StatelessWidget {
  final String filePath;
  final String message;
  final String time;
  final String fileType; // إضافة نوع الملف لعرض الأيقونة المناسبة

  const ReplyFileDisplay({
    Key? key,
    required this.filePath,
    required this.message,
    required this.time,
    required this.fileType, // استقبال نوع الملف كمدخل
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFileIcon(fileType), // استدعاء الدالة التي تبني أيقونة الملف
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  filePath,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة تقوم بتحديد الأيقونة المناسبة بناءً على نوع الملف
  Widget _buildFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf, size: 30, color: Colors.red);
      case 'doc':
      case 'docx':
        return Icon(Icons.description, size: 30, color: Colors.blue);
      default:
        return Icon(Icons.insert_drive_file, size: 30, color: Colors.indigo);
    }
  }
}
