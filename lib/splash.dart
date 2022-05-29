/**
 * Created by : Ayush Kumar
 * Created on : 29-05-2022
 */
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Splash extends StatefulWidget {
  CameraDescription camera;
  Splash({Key? key, required this.camera}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: widget.camera),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
