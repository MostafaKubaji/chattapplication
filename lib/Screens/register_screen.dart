import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:chattapplication/Model/face_features.dart';
import 'package:chattapplication/Services/extract_features.dart';
import 'package:chattapplication/Widgets/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:chattapplication/config.dart';
import 'dart:math' as math;
import '../Model/user_model.dart';
import 'package:flutter_face_api/face_api.dart' as regula;
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  String? _image;
  FaceFeatures? _faceFeatures;

  bool isRegistering = false;
  final _formFieldKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Register User",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CameraView(
              onImage: (image)
              {
                _setImage(image);
                setState(() {
                  _image = base64Encode(image);
                });
              },
              onInputImage: (inputImage) async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff023E7D),
                    ),
                  ),
                );

                await extractFaceFeatures(inputImage, _faceDetector).then((faceFeatures) {
                  Navigator.of(context).pop(); // Close the loading dialog
                  if (faceFeatures == null) {
                    // If no face detected, clear the stored image and show a message
                    setState(() {
                      _image = null;
                      _faceFeatures = null;
                    });
                    showToast('Face not detected. Please capture a new image.');
                  } else {
                    setState(() {
                      _faceFeatures = faceFeatures;
                    });
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formFieldKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter the name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter user name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff023E7D),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Start Registration",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (_faceFeatures != null) {
                            if (_formFieldKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              );

                              String userId = const Uuid().v1();

                              var user = {
                                "id": userId,
                                "name": _nameController.text.trim(),
                                "image": _image,
                                "faceFeatures": _faceFeatures,
                              };
///===========
                                // أرسل طلب GET إلى الخادم لجلب المستخدمين من MongoDB
                                final response = await http.get(Uri.parse('$serverIP/users'));

                                if (response.statusCode == 200) {
                                  // تحويل الاستجابة إلى JSON
                                  final List<dynamic> data = jsonDecode(response.body);
                                  users.clear(); // مسح قائمة المستخدمين
                                  log(data.length.toString(), name: "Total Registered Users");
                                  for (var userData in data) {
                                    // تحويل البيانات إلى نموذج UserModel
                                    UserModel user = UserModel.fromJson(userData);

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
                                 match =await matchFaces(); // بدء عملية مطابقة الوجوه
                                }
                                if(!match) {
                                  try {
                                    final response = await http.post(
                                      Uri.parse('$serverIP/register'),

                                      headers: {
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(user),
                                    );

                                    if (response.statusCode == 201) {
                                      showToast('Registration successful');
                                      Future.delayed(
                                          const Duration(seconds: 1), () {
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      final responseBody = response.body;
                                      showToast(
                                          'Registration failed! Server response: $responseBody');
                                    }
                                  } catch (e) {
                                    showToast(
                                        'Registration failed. Please try again and ensure the server is running.');
                                  } finally {
                                    Navigator.of(context).pop();
                                  }
                                }
                                else{
                                  Navigator.of(context).pop();
                                  _showFailureDialog(
                                    title: "Redeem Failed", // عنوان حوار الفشل
                                    description: "This face is already in the system. Please take a picture of a different face.", // وصف حوار الفشل

                                  );

                                  }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
  Future _setImage(Uint8List imageToAuthenticate) async {
    image2.bitmap = base64Encode(imageToAuthenticate);
    image2.imageType = regula.ImageType.PRINTED;

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

  Future<bool> matchFaces() async {
    bool faceMatched = false;
    for (var user in users) {
      final userModel = user.first as UserModel;

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
          faceMatched = true;
          match=true;


        } else {
          faceMatched = false; // تعيين حالة تطابق الوجه إلى false
          match=false;
        }
      });
      return match;
    }
    return match;

    }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
    );
  }
  String _similarity = "error";
  bool match=false;
  var image1 = regula.MatchFacesImage(); // الصورة الأولى لمطابقة الوجوه
  var image2 = regula.MatchFacesImage();
  List<List> users = [];
  int trialNumber = 1;

}