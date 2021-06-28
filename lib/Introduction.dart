import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:temp_recor/variable.dart';

import 'loginscreen.dart';
class IntroductionAuthScreen extends StatefulWidget {

  @override
  _IntroductionAuthScreenState createState() => _IntroductionAuthScreenState();
}

class _IntroductionAuthScreenState extends State<IntroductionAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [PageViewModel(
        title: "TempRecor",
        body: "Here you can write the description of the page, to explain someting...",
        image: Center(child: Image.asset("images/logo.png", height: 175.0)),
        decoration: const PageDecoration(
          pageColor: themeColor,
        ),
      )],
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: themeData.primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
      showNextButton: false,
      done: const Text("Next", style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: themeColor)),
      onDone: (){Navigator.push(context,
          MaterialPageRoute(builder: (context) => LoginScreen()));},
    );
  }
}
