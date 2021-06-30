import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as im;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> _getImageAndDetectFace() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    final imageFile = File(pickedFile!.path);
    final image = await FirebaseVisionImage.fromFile(imageFile);
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
  faceDetector.close();
  }
  late Widget widgetHolder;
@override
void initState() {
    widgetHolder=Text("True", style: TextStyle(fontSize: 40),);
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
                        onPressed: ()async {
                          print("Success1");
                          await _getImageAndDetectFace();
                          setState(()  {
                            isFace = true;
                            print("Success2");
                            widgetHolder=ImageAndFaces(imageFile: _imageFile, faces: _faces,uImage: _uImage,);
                            print(isFace);
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
            child:widgetHolder,
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

class FaceCoordinates extends StatefulWidget {
  const FaceCoordinates({Key? key, required this.imageFile, required this.face, required this.uImage}) : super(key: key);
  final Face face;
  final Uint8List uImage;
  final File imageFile;

  @override
  _FaceCoordinatesState createState() => _FaceCoordinatesState();
}

class _FaceCoordinatesState extends State<FaceCoordinates> {
  late im.Image dImage;

  late im.Image displayFace;

  late List<int> jpgInt;

  late Image croppedImage;

  late Directory directory;

  late String path;

  late String imagePath;

  void inFirst() async{
    var uuid = Uuid();
     dImage = im.decodeJpg(widget.uImage);
    displayFace = im.copyCrop(
      dImage, widget.face.boundingBox.topLeft.dx.toInt(),
      widget.face.boundingBox.topLeft.dy.toInt(),
      widget.face.boundingBox.width.toInt(),
      widget.face.boundingBox.height.toInt(),);
     jpgInt = im.encodeJpg(displayFace);
    croppedImage = Image.memory(jpgInt as Uint8List);

    directory = (await getExternalStorageDirectory())!;
    path = directory.path;
    await Directory('$path/images').create(recursive: true);
     imagePath = '$path/images/${uuid.v4()}.jpg';
    File(imagePath).writeAsBytesSync(jpgInt
    );
  }

  @override
  Widget build(BuildContext context) {
    inFirst();
    return Container(
      child: Image(
          image: Image.file(File(imagePath)) ),

    );
  }
}
