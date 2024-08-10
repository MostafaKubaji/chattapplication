import 'package:flutter/material.dart';

class MessageModel{
String? type;
String? message;
String? time;
String? path;
bool? isImage;
MessageModel({this.message,this.type,this.time,@required this.path,this.isImage});
}