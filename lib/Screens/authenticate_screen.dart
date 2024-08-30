import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:chattapplication/Model/ChatModel.dart';
import 'package:chattapplication/Screens/Homescreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http; // استيراد مكتبة HTTP
import 'package:chattapplication/Model/face_features.dart';
import 'package:chattapplication/Model/user_model.dart';
import 'package:chattapplication/Screens/authenticated_user_screen.dart';
import 'package:chattapplication/Services/extract_features.dart';
import 'package:chattapplication/Widgets/camera_view.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:chattapplication/config.dart';
import 'package:dio/dio.dart'; // استخدم Dio كبديل لـ http لأنه يدعم JSON بشكل أفضل

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  @override
  ChatModel? sourceChat;
  List<ChatModel> chatsModels = [
    ChatModel(
      name: 'مصطفى',
      isGroup: false,
      currentMessage: 'hi mostafa',
      time: "4:00",
      icon: 'person.svg',
      id: 1.toString(),
    ),
    ChatModel(
      name: 'عمر المرعي',
      isGroup: false,
      currentMessage: 'hi Omar',
      time: "5:00",
      icon: 'person.svg',
      id: 2.toString(),
    ),
    ChatModel(
      name: 'محمد سكندر',
      isGroup: false,
      currentMessage: 'hi Mohamed',
      time: "8:00",
      icon: 'person.svg',
      id: 3.toString(),
    ),
    ChatModel(
      name: "الأستاذ باسم",
      isGroup: false,
      currentMessage: 'call me in 2:00',
      time: "8:30",
      icon: 'person.svg',
      id: 4.toString(),
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "User Authenticate",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xff023E7D),
        shadowColor: const Color(0xff33415C),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CameraView(
                onImage: (image) {
                  _setImage(image);
                },
                onInputImage: (inputImage) async {
                  setState(() => isMatching = true);
                  _faceFeatures = (await extractFaceFeatures(
                      inputImage, _faceDetector));
                  if (_faceFeatures == null) {
                    // If no face detected, clear the stored image and show a message
                    setState(() {
                      showToast('Face not detected. Please capture a new image.');
                      isMatching = true;
                      _canAuthenticate= false;

                    });

                  } else {
                    setState(() {
                      isMatching = false;
                      _canAuthenticate= true;});
                  }

                },
              ),
            ),
            const SizedBox(height: 24),
            if (_canAuthenticate)
              Center(
                child: isMatching
                    ? const CircularProgressIndicator(
                  color: Color(0xff023E7D),
                )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff023E7D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36.0, vertical: 12.0),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text("Authenticate"),
                  onPressed: () {
                    setState(() => isMatching = true);
                    _fetchUsersAndMatchFace();
                  },
                ),
              ),
            const SizedBox(height: 38),
          ],
        ),
      ),
    );
  }



  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

    setState(() {
      _canAuthenticate = true;
    });
  }

  double compareFaces(FaceFeatures face1, FaceFeatures face2) {
    double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
    double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);

    double ratioEar = distEar1 / distEar2;

    double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
    double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);

    double ratioEye = distEye1 / distEye2;

    double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
    double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);

    double ratioCheek = distCheek1 / distCheek2;

    double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
    double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);

    double ratioMouth = distMouth1 / distMouth2;

    double distNoseToMouth1 = euclideanDistance(face1.noseBase!, face1.bottomMouth!);
    double distNoseToMouth2 = euclideanDistance(face2.noseBase!, face2.bottomMouth!);

    double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;

    double ratio =
        (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
    log(ratio.toString(), name: "Ratio");

    return ratio;
  }

  double euclideanDistance(Points p1, Points p2) {
    final sqr =
    math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
    return sqr;
  }
List<UserModel> allUsers=[];
  _fetchUsersAndMatchFace() async {
    try {
      // أرسل طلب GET إلى الخادم لجلب المستخدمين من MongoDB
      final response = await http.get(Uri.parse('$serverIP/users'));

      if (response.statusCode == 200) {
        // تحويل الاستجابة إلى JSON
        final List<dynamic> data = jsonDecode(response.body);
        users.clear(); // مسح قائمة المستخدمين

        log(data.length.toString(), name: "Total Registered Users");
allUsers=[];
        for (var userData in data) {
          // تحويل البيانات إلى نموذج UserModel
          UserModel user = UserModel.fromJson(userData);
          allUsers.add(user);
          // قارن ميزات الوجه مع المستخدمين المسجلين
          double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
          if (similarity >= 0.8 && similarity <= 1.5) {
            users.add([user, similarity]);
          }
        }

        log(users.length.toString(), name: "Filtered Users");
        setState(() {

          users.sort((a, b) => (((a.last as double) - 1).abs())
              .compareTo(((b.last as double) - 1).abs()));
        });




        _matchFaces(); // بدء عملية مطابقة الوجوه
      } else {
        throw Exception("Failed to load users:No Users Registered");
      }
    } catch (e) {
      log("Getting User Error: $e");
      setState(() => isMatching = false);
      showToast("Something went wrong. Please try again.");
    }
  }


  _matchFaces() async {

    bool faceMatched = false;
// print("---------------------"*100);

// print(users);
    for (var user in users) {
      final userModel = user.first as UserModel;
      ;
      image1.bitmap = (user.first as UserModel).image; // تعيين الصورة من نموذج المستخدم
      image1.imageType = regula.ImageType.PRINTED; // تعيين نوع الصورة

      var request = regula.MatchFacesRequest();
      request.images = [image1, image2];
      dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));

      var response = regula.MatchFacesResponse.fromJson(json.decode(value));

      if (response == null) {
        log("MatchFacesResponse is null");
        continue;
      }
      dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
          jsonEncode(response!.results), 0.75);


      var split =
      regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str)); // تحليل نتيجة تقسيم التشابه
      setState(() {
        _similarity = split!.matchedFaces.isNotEmpty
            ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) // تعيين قيمة التشابه
            : "error";
        log("similarity: $_similarity"); // تسجيل قيمة التشابه

        if (_similarity != "error" && double.parse(_similarity) > 90.00) { // إذا كان التشابه أكثر من 90%
          faceMatched = true; // تعيين حالة تطابق الوجه إلى true
          loggingUser = user.first; // تعيين المستخدم الذي تم تسجيل الدخول إليه
        } else {
          faceMatched = false; // تعيين حالة تطابق الوجه إلى false
        }
      });
      if (faceMatched) { // إذا تم تطابق الوجه
        setState(() {
          trialNumber = 1; // إعادة تعيين عدد المحاولات
          isMatching = false; // تعيين حالة التحقق إلى false
        });

        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Homescreen1(
                  chatmodels: chatsModels,
                  sourcechat: sourceChat,
                  allUsers: allUsers,
                  currentUser: loggingUser,
                ),/// homepage chat
            ),
          );
        }
        break; // إنهاء الحلقة
      }
    }

    if (!faceMatched) { // إذا لم يتم تطابق الوجه
      if (trialNumber == 4) { // إذا كان عدد المحاولات 4
        setState(() {
          isMatching = false; // تعيين حالة التحقق إلى false
          trialNumber++; // زيادة عدد المحاولات
        }); // إعادة تعيين عدد المحاولات إلى 1
        _showFailureDialog(
          title: "Redeem Failed", // عنوان حوار الفشل
          description: "Face doesn't match. Please try again.", // وصف حوار الفشل

        );
      } else if (trialNumber == 3) { // إذا كان عدد المحاولات 3
        setState(() {
          isMatching = false; // تعيين حالة التحقق إلى false
          trialNumber++; // زيادة عدد المحاولات
        });
        ;
      } else { // إذا كان عدد المحاولات أقل من 3
        setState(() {
          showToast('Face not detected. Please capture a new image.');
          isMatching = false;
          trialNumber++;

        });
        _showFailureDialog(
          title: "Redeem Failed", // عنوان حوار الفشل
          description: "Face doesn't match. Please try again.", // وصف حوار الفشل

        );
      }
    }
  }


  Future<void> _showFailureDialog({
    required String title,
    required String description,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title), // عنوان الحوار
          content: Text(description), // وصف الحوار
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار عند النقر على الزر
              },
              child: const Text(
                "Ok", // نص الزر
                style: TextStyle(
                  color: Color(0xff023E7D), // تعيين لون النص
                ),
              ),
            )
          ],
        );
      },
    );
  }
  void showToast(msg) { // عرض رسالة منبثقة
    Fluttertoast.showToast(
      msg: msg, // نص الرسالة
      toastLength: Toast.LENGTH_SHORT, // طول الرسالة
      gravity: ToastGravity.BOTTOM, // موضع الرسالة
      timeInSecForIosWeb: 5, // الوقت للرسائل على iOS والويب
    );
  }
  final FaceDetector _faceDetector = FaceDetector( // إنشاء كاشف الوجوه
    options: FaceDetectorOptions(
      enableLandmarks: true, // تفعيل المعالم
      performanceMode: FaceDetectorMode.accurate, // وضع الأداء الدقيق
    ),
  );
  FaceFeatures? _faceFeatures; // ميزات الوجه

  var image1 = regula.MatchFacesImage(); // الصورة الأولى لمطابقة الوجوه
  var image2 = regula.MatchFacesImage(); // الصورة الثانية لمطابقة الوجوه



  bool isMatching = false;
  bool _canAuthenticate = false;
  List<List> users = [];
  String _similarity = "error";
  UserModel? loggingUser;
  int trialNumber = 1;


  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}
