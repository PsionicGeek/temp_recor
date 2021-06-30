import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as im;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp_recor/cropfaces.dart';

class GetFaceImage extends StatefulWidget {
  const GetFaceImage({Key? key}) : super(key: key);

  @override
  _GetFaceImageState createState() => _GetFaceImageState();
}

class _GetFaceImageState extends State<GetFaceImage> {
  late File _imageFile;
  late List<Face> _faces;
  ImagePicker picker = ImagePicker();
  late Uint8List _uImage;

  void _getImageAndDetectFace() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    final imageFile = File(pickedFile!.path);
    final image = FirebaseVisionImage.fromFile(imageFile);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    final Uint8List uImage= await imageFile.readAsBytes();
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
        _faces = faces;
        _uImage=uImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFace = false;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detect Face"),
      ),
      body: Column(
        children: [
          Container(
            width:MediaQuery.of(context).size.width ,
            height:MediaQuery.of(context).size.height/3,
            child:  Container(
              width:MediaQuery.of(context).size.width ,
                    height:MediaQuery.of(context).size.height/1.5 ,
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            isFace = true;
                            _getImageAndDetectFace();
                          });
                        },
                        icon: Icon(Icons.camera),
                        label: Text("Add Face"),
                      ),
                    ),
                  )

          ),

          Container(
            width:MediaQuery.of(context).size.width ,
            height:MediaQuery.of(context).size.height/3,
            child:isFace?ImageAndFaces(imageFile: _imageFile, faces: _faces,uImage: _uImage,):null,
          )
        ],
      ),
      // body: ImageAndFaces(
      //   imageFile: _imageFile,
      //   faces: _faces,
      // ),
    );
  }
}

class ImageAndFaces extends StatelessWidget {
  const ImageAndFaces({Key? key, required this.imageFile, required this.faces, required this.uImage})
      : super(key: key);
  final File imageFile;
  final List<Face> faces;
  final Uint8List uImage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Flexible(
        //   flex: 2,
        //   child: Container(
        //     constraints: BoxConstraints.expand(),
        //     child: Image.file(
        //       imageFile,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        Flexible(
            flex: 2,
            child: FaceCoordinates(
                        face: faces[0], imageFile: imageFile,uImage: uImage,
                      ),
            )
      ],
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  const FaceCoordinates({Key? key, required this.imageFile, required this.face, required this.uImage}) : super(key: key);
  final Face face;
  final Uint8List uImage;
  final File imageFile;
  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    final im.Image dImage = im.decodeJpg(uImage);
    return Container(
      child: Image(
          image: im.copyCrop(dImage,face.boundingBox.topLeft.dx.toInt(),
          face.boundingBox.topLeft.dy.toInt(),
          face.boundingBox.width.toInt(),
          face.boundingBox.height.toInt(),) as ImageProvider ),

    );
  }
}
