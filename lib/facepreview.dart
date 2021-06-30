import 'package:flutter/material.dart';
class PreviewFace extends StatefulWidget {

  @override
  _PreviewFaceState createState() => _PreviewFaceState();
}

class _PreviewFaceState extends State<PreviewFace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview Face",style: TextStyle(color: Colors.white),),
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
        tooltip: 'Done',
        child: new Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Scaffold(),
    );
  }
}
