import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp_recor/getimage.dart';
import 'package:temp_recor/main.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TempRecor",style: TextStyle(color: Colors.white),),),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('To be edited by sid'),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('SignOut'),
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NavigationPage()),);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
        floatingActionButton: new FloatingActionButton(
          onPressed: (){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>GetFaceImage(),
              ),
            );
          },
          tooltip: 'Add',
          child: new Icon(Icons.person_add_sharp),
        ),
      body: Scaffold(
        //TODO Add cards
      ),
    );
  }
}
