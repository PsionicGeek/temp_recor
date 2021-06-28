import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:temp_recor/dashboard_screen.dart';
import 'package:temp_recor/Introduction.dart';
import 'package:temp_recor/variable.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: NavigationPage(),
    );
  }
}


class NavigationPage extends StatefulWidget {

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool isSigned = false;
  @override
  void setState(fn){
    if(mounted) {
      super.setState(fn);
    }
  }
  void initState() {
    super.initState();
     FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        isSigned = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

          return Scaffold(
            body: isSigned == true ? DashboardScreen():IntroductionAuthScreen() ,
          );
        }

}
