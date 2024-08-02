import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OthersStatus extends StatelessWidget {
  const OthersStatus({
    super.key,
    this.name,
    this.time,
    this.imageName,
    this.isSeen,
    this.statusNum,
  });
  final String? name;
  final String? time;
  final String? imageName;
  final bool? isSeen;
  final int? statusNum;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomPaint(
        painter: StatusPainter(isSeen: isSeen,statusNum:statusNum),
        child: CircleAvatar(
          radius: 26,
          backgroundImage: AssetImage(imageName!),
        ),
      ),
      title: Text(
        name!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xff023E7D), // لون من المجموعة المقدمة
        ),
      ),
      subtitle: Text(
        "Today at, $time",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xff7D8597), // لون من المجموعة المقدمة
        ),
      ),
    );
  }
}

degreeToAngle(double degree) {
  return degree * pi / 180;
}

class StatusPainter extends CustomPainter {
  bool? isSeen;
  int? statusNum;
  StatusPainter({this.isSeen, this.statusNum});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 6.0
      ..color = isSeen! ? Colors.grey : Color(0xff21bfa6)
      ..style = PaintingStyle.stroke;
    drawArc(canvas, size, paint);
  }

  void drawArc(Canvas canvas, Size size, Paint paint) {
    if(statusNum==1){
          canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        degreeToAngle(0), degreeToAngle(360), false, paint);
    }
    else{
      double degree=-90;
      double arc=360/(statusNum??1);
      for (int i=0;i<(statusNum??0);i++){
    canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        degreeToAngle(degree+4), degreeToAngle(arc-8), false, paint);
        degree+=arc;
      }

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
