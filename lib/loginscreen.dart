import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:temp_recor/variable.dart';
import 'dashboard_screen.dart';


class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

Future<String> _login(LoginData login) {
  return Future.delayed(loginTime).then((_) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: login.name, password: login.password);
    }
    catch(e){
      print(e);
      return e.message;
    }
    return null;
  });
}

  Future<String> _signup(LoginData signup) {
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: signup.name,
            password: signup.password)
            .then((signedUser) {
          userCollection.doc(signedUser.user.uid).set({
            'email': signup.name,
            'password': signup.password,

          });
        });
      }
      catch(e){
        print(e);
        return e.message;
      }
      return null;
    });
  }
  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name );
    }
    catch(e) {
      return e.message;
    }

    return "Password Link has been sent!!";

    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'TempRecor',
      logo: 'images/logo.png',
      onLogin: _login,
      onSignup: _signup,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}