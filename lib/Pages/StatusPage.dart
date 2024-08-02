import 'package:chattapplication/CustomUI/StatusPageF/HeadOwnStatus.dart';
import 'package:chattapplication/CustomUI/StatusPageF/OthersStatus.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Color(0xff7D8597), // لون فاتح من المجموعة
              elevation: 8,
              onPressed: () {},
              child: Icon(
                Icons.edit,
                color: Color(0xff001233), // لون داكن من المجموعة
              ),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Color(0xff0466C8), // لون فاتح من المجموعة
            elevation: 5,
            child: Icon(Icons.camera_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadOwnStatus(),
            lable("Recent updates"),
            OthersStatus(
              name: "Omar",
              imageName: "assets/m2.png",
              time: "10:30",
              isSeen: false,
              statusNum: 1,
            ),
            OthersStatus(
              name: "Mohamad",
              imageName: "assets/m3.png",
              time: "23:50",
                            isSeen: false,
              statusNum: 2,
            ),
            OthersStatus(
              name: "Ali",
              imageName: "assets/m4.png",
              time: "12:30",
                            isSeen: false,
              statusNum: 3,
            ),
            SizedBox(
              height: 10,
            ),
            lable("Viewed updates"),
            OthersStatus(
              name: "Mohamad",
              imageName: "assets/m3.png",
              time: "23:50",
                            isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: "Ali",
              imageName: "assets/m4.png",
              time: "12:30",
                            isSeen: true,
              statusNum: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget lable(String lableName) {
    return Container(
      height: 34,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff5C677D), // لون من المجموعة
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          lableName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white, // لون النص أبيض للوضوح
          ),
        ),
      ),
    );
  }
}
