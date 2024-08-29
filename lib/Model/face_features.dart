// تعريف فئة FaceFeatures التي تمثل ملامح الوجه
class FaceFeatures {
  // تعريف النقاط الخاصة بكل ميزة في الوجه
  Points? rightEar;    // نقطة تمثل الأذن اليمنى
  Points? leftEar;     // نقطة تمثل الأذن اليسرى
  Points? rightEye;    // نقطة تمثل العين اليمنى
  Points? leftEye;     // نقطة تمثل العين اليسرى
  Points? rightCheek;  // نقطة تمثل الخد الأيمن
  Points? leftCheek;   // نقطة تمثل الخد الأيسر
  Points? rightMouth;  // نقطة تمثل زاوية الفم اليمنى
  Points? leftMouth;   // نقطة تمثل زاوية الفم اليسرى
  Points? noseBase;    // نقطة تمثل قاعدة الأنف
  Points? bottomMouth; // نقطة تمثل الجزء السفلي من الفم

  // مُنشئ فئة FaceFeatures
  FaceFeatures({
    this.rightMouth,   // زاوية الفم اليمنى
    this.leftMouth,    // زاوية الفم اليسرى
    this.leftCheek,    // الخد الأيسر
    this.rightCheek,   // الخد الأيمن
    this.leftEye,      // العين اليسرى
    this.rightEar,     // الأذن اليمنى
    this.leftEar,      // الأذن اليسرى
    this.rightEye,     // العين اليمنى
    this.noseBase,     // قاعدة الأنف
    this.bottomMouth,   // الجزء السفلي من الفم
  });

  // دالة مصنع لتحويل البيانات من صيغة JSON إلى كائن من نوع FaceFeatures
  factory FaceFeatures.fromJson(Map<String, dynamic> json) => FaceFeatures(
    rightMouth: Points.fromJson(json["rightMouth"]),   // تحويل زاوية الفم اليمنى من JSON
    leftMouth: Points.fromJson(json["leftMouth"]),     // تحويل زاوية الفم اليسرى من JSON
    leftCheek: Points.fromJson(json["leftCheek"]),     // تحويل الخد الأيسر من JSON
    rightCheek: Points.fromJson(json["rightCheek"]),   // تحويل الخد الأيمن من JSON
    leftEye: Points.fromJson(json["leftEye"]),         // تحويل العين اليسرى من JSON
    rightEar: Points.fromJson(json["rightEar"]),       // تحويل الأذن اليمنى من JSON
    leftEar: Points.fromJson(json["leftEar"]),         // تحويل الأذن اليسرى من JSON
    rightEye: Points.fromJson(json["rightEye"]),       // تحويل العين اليمنى من JSON
    noseBase: Points.fromJson(json["noseBase"]),       // تحويل قاعدة الأنف من JSON
    bottomMouth: Points.fromJson(json["bottomMouth"]), // تحويل الجزء السفلي من الفم من JSON
  );

  // دالة لتحويل كائن FaceFeatures إلى صيغة JSON
  Map<String, dynamic> toJson() => {
    "rightMouth": rightMouth?.toJson() ?? {},   // تحويل زاوية الفم اليمنى إلى JSON
    "leftMouth": leftMouth?.toJson() ?? {},     // تحويل زاوية الفم اليسرى إلى JSON
    "leftCheek": leftCheek?.toJson() ?? {},     // تحويل الخد الأيسر إلى JSON
    "rightCheek": rightCheek?.toJson() ?? {},   // تحويل الخد الأيمن إلى JSON
    "leftEye": leftEye?.toJson() ?? {},         // تحويل العين اليسرى إلى JSON
    "rightEar": rightEar?.toJson() ?? {},       // تحويل الأذن اليمنى إلى JSON
    "leftEar": leftEar?.toJson() ?? {},         // تحويل الأذن اليسرى إلى JSON
    "rightEye": rightEye?.toJson() ?? {},       // تحويل العين اليمنى إلى JSON
    "noseBase": noseBase?.toJson() ?? {},       // تحويل قاعدة الأنف إلى JSON
    "bottomMouth": bottomMouth?.toJson() ?? {}, // تحويل الجزء السفلي من الفم إلى JSON
  };
}

// تعريف فئة Points التي تمثل نقطة ثنائية الأبعاد
class Points {
  int? x; // الإحداثي السيني (X)
  int? y; // الإحداثي الصادي (Y)

  // مُنشئ فئة Points
  Points({
    required this.x, // الإحداثي السيني (X) مطلوب
    required this.y, // الإحداثي الصادي (Y) مطلوب
  });

  // دالة مصنع لتحويل البيانات من صيغة JSON إلى كائن من نوع Points
  factory Points.fromJson(Map<String, dynamic> json) => Points(
    x: (json['x'] ?? 0) as int, // تحويل الإحداثي السيني من JSON مع قيمة افتراضية 0
    y: (json['y'] ?? 0) as int, // تحويل الإحداثي الصادي من JSON مع قيمة افتراضية 0
  );

  // دالة لتحويل كائن Points إلى صيغة JSON
  Map<String, dynamic> toJson() => {'x': x, 'y': y}; // تحويل الإحداثيات إلى JSON
}
