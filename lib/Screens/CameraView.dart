import 'dart:io';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({super.key, this.path});
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.crop_rotate,
              size: 28,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.emoji_emotions_outlined,
              size: 28,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.title,
              size: 28,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            if (path != null)
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: Image.file(
                  File(path!),
                  fit: BoxFit.cover,
                ),
              ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                color: Colors.black38,
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add caption...",
                    prefix: Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 18,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    suffixIcon: CircleAvatar(
                      radius: 28,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
            if (path == null)
              Center(
                child: Text(
                  'No image selected',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
