import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:chattapplication/Screens/CameraView.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cameras;

Future<void> setupCameras() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, this.onImageSend});
  final Function(String,File, String)? onImageSend;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? cameraValue;
  bool flash = false;
  bool isCameraFront = true;
  double transformCamera = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    if (cameras == null || cameras!.isEmpty) {
      await setupCameras();
    }
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.high);
      cameraValue = _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } else {
      print('No cameras found');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController!),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            flash = !flash;
                          });
                          flash
                              ? _cameraController?.setFlashMode(FlashMode.torch)
                              : _cameraController?.setFlashMode(FlashMode.off);
                        },
                        icon: Icon(
                          flash ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          takePhoto(context);
                        },
                        child: Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isCameraFront = !isCameraFront;
                            transformCamera = transformCamera + pi;
                          });
                          int cameraPosition = isCameraFront ? 0 : 1;
                          if (cameras != null && cameras!.isNotEmpty) {
                            _cameraController = CameraController(
                                cameras![cameraPosition], ResolutionPreset.high);
                            cameraValue = _cameraController!.initialize();
                          }
                        },
                        icon: Transform.rotate(
                          angle: transformCamera,
                          child: Icon(Icons.flip_camera_ios_outlined),
                        ),
                        color: Colors.white,
                        iconSize: 40,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Hold for video, tap for photo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    final xFile = await _cameraController?.takePicture();
    final imagePath = xFile?.path;
    if (imagePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => CameraViewPage(
            path: imagePath,
            onImageSend: widget.onImageSend,
          ),
        ),
      ).then((value) {
                                  Navigator.pop(context);

      },);
    }
  }
}
