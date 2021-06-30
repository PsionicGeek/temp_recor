import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:temp_recor/painter/face_detector_painter.dart';

import 'Visions/camera_view.dart';
import 'facepreview.dart';

class CaptureFace extends StatefulWidget {

  @override
  _CaptureFaceState createState() => _CaptureFaceState();
}

class _CaptureFaceState extends State<CaptureFace> {
  FaceDetector faceDetector =
  GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  ));
  bool isBusy = false;
  CustomPaint? customPaint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture Face",style: TextStyle(color: Colors.white),),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back_ios_outlined),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewFace(),
            ),
          );
        },
        tooltip: 'Capture',
        child: new Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CameraView(
        title: 'Face Detector',
        customPaint: customPaint,
        onImage: (inputImage) {
          processImage(inputImage);
        },),
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    print('Found ${faces.length} faces');
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
}
  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }
  }