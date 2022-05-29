/**
 * Created by : Ayush Kumar
 * Created on : 29-05-2022
 */
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'take_picture.dart';

class Splash extends StatefulWidget {
  Splash({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      // Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();

      // Get a specific camera from the list of available cameras.
      final firstCamera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: firstCamera),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff004AAD),
      body: Container(
        color: Color(0xff004AAD),
        child: Center(
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
