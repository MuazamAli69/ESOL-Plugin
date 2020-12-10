import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:esol/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Flutter Packages
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

import 'package:esol/screens/routes.gr.dart';
import 'package:http/http.dart' as http;
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/painting.dart' as painting;

class VeifyFaceDetect extends StatefulWidget {
  @override
  _VeifyFaceDetectState createState() => _VeifyFaceDetectState();
}

class _VeifyFaceDetectState extends State<VeifyFaceDetect> {
  // File _imageFile;
  // static const platform = const MethodChannel;
  // static const platform = const MethodChannel();
  // static const platform = const MethodChannel('flutter.native/helper');
  // String _responseFromNativeCode = 'Waiting for Response...';
  // Future<void> responseFromNativeCode() async {
  //   String response = "";
  //   try {
  //     final String result = await platform.invokeMethod('helloFromNativeCode');
  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  //   setState(() {
  //     _responseFromNativeCode = response;
  //   });
  // }

  List<Face> faces = [];
  final _scanKey = GlobalKey<CameraMlVisionState>();
  CameraLensDirection cameraLensDirection = CameraLensDirection.front;
  FaceDetector detector =
      FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    enableClassification: true,
    enableTracking: true,
    enableLandmarks: true,
    mode: FaceDetectorMode.accurate,
  ));
  String detectString = 'No Face Found';
  String verifiedString = 'Data';

  Future<void> uploadData(
      {String base64Image,
      bool template,
      bool cropImage,
      bool faceAttributes,
      bool facialFeatures,
      bool icaoAttributes,
      String imgPath}) async {
    setState(() {
      detectString = 'Verifying Face';
    });
    final url = 'https://dot.innovatrics.com/core/api/v6/face/detect';
    final directory = await getApplicationDocumentsDirectory();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'image': {
            "data": base64Image,
            "faceSizeRatio": {
              "min": 0.01,
              "max": 0.9,
            }
          },
          'template': template,
          'cropImage': cropImage,
          'faceAttributes': faceAttributes,
          'facialFeatures': facialFeatures,
          'icaoAttributes': icaoAttributes,
        },
      ),
    );

    if (response.statusCode == 200) {
      var deleteVar = File(imgPath);

      // setState(() {
      print("Here is the code");
      // });
      if (response.body.toString().contains('NO_FACE_DETECTED')) {
        // deleteVar.delete(recursive: true);
        // deleteVar.deleteSync(recursive: true);
        deleteVar.delete();
        // painting.imageCache.clear();
        // deleteVar.rename(imgPath + ".i");

        // setState(() {
        //   detectString = 'Move Face Closer';
        // });
        print('This is the response ${response.body}');
      }
      if (!response.body.toString().contains('NO_FACE_DETECTED')) {
        print('This is the Directory Path: ${directory.path}');
        // directory.deleteSync(recursive: true);
        // deleteVar.deleteSync(recursive: true);
        // deleteVar.rename(imgPath + ".i");s
        deleteVar.delete();
        //        deleteVar.delete();
        // painting.imageCache.clear();
        // setState(() {
        //   detectString = 'Face is Verified';
        // });
        print('This is the another response ${response.body}');
        // Navigator.of(context).pushNamed(Routes.homePage);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('data', "ok");

        setState(() {
          verifiedString = 'Face is Verified';
        });
        await Future.delayed(Duration(seconds: 4), () {});
        if (verifiedString == 'Face is Verified') {
          Navigator.of(context).pop();
        }

        // Navigator.of(context).pop();
      }
    }
  }

  _takeScreenShot() async {
    final dataValue = await NativeScreenshot.takeScreenshot();
    if (dataValue != null) {
      var imageFile = File(dataValue);
      // var imgPath = dataValue;

      Uint8List byteFile = imageFile.readAsBytesSync();
      String base64Image = base64Encode(byteFile);
      uploadData(
        base64Image: base64Image,
        cropImage: true,
        faceAttributes: true,
        facialFeatures: true,
        icaoAttributes: true,
        template: true,
        imgPath: dataValue,
      );
      // responseFromNativeCode().then((value) => print('The Method Channel i'));
    }
  }

  @override
  Widget build(BuildContext context) {
    String layoutHeight = MediaQuery.of(context).size.height.toString();
    String layoutWidth = MediaQuery.of(context).size.width.toString();

    print('This is data String $detectString');
    print('This is the height of the page : $layoutHeight');
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 85, 255, 1),
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Stack(children: [
        Align(
            alignment: Alignment.topCenter,
            child: (verifiedString == "Data")
                ? Text(detectString,
                    style: TextStyle(color: Colors.white, fontSize: 30))
                : Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 80,
                  )),
        // : Text(detectString,
        //     style: TextStyle(color: Colors.white, fontSize: 30)),

        Center(
          child: Container(
            // height: MediaQuery.of(context).size.height / 3.2,
            // width: MediaQuery.of(context).size.width * 0.7,
            height: 300,
            width: 300,
            child: ClipOval(
              child: CameraMlVision<List<Face>>(
                key: _scanKey,
                cameraLensDirection: cameraLensDirection,
                detector: (FirebaseVisionImage image) {
                  return detector.processImage(image);
                },
                // overlayBuilder: (c) {
                //   return Text('Data is Verified');
                // },
                onResult: (faces) {
                  if (faces == null || faces.isEmpty || !mounted) {
                    return;
                  }

                  setState(() {
                    faces = []..addAll(faces);
                    if (faces[0].rightEyeOpenProbability >= 0.9 &&
                        faces[0].leftEyeOpenProbability >= 0.9 &&
                        faces[0].boundingBox.isEmpty == false) {
                      detectString = 'Face detected';
                      _takeScreenShot();
                    }
                    if (faces[0].rightEyeOpenProbability <= 0.5 &&
                        faces[0].leftEyeOpenProbability <= 0.5) {
                      detectString = 'Open your Eyes';
                    }
                  });
                },
                onDispose: () {
                  detector.close();
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
