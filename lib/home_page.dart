import 'dart:async';

import 'package:camera/camera.dart';
import 'package:em_music/second_screen.dart';
import 'package:em_music/service.dart';
import 'package:em_music/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  CameraDescription selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front);

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: Splash(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: selectedCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _service = Service(
      "https://3aeb-2409-4052-2e1a-d52a-ad09-b112-cf14-8cce.in.ngrok.io");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        actions: [
          //settings
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //show dialog to input url
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Enter base url'),
                  content: TextField(
                    onChanged: (value) {
                      _service.baseUrl = value;
                    },
                  ),
                  actions: [
                    FlatButton(
                      child: const Text('OK'),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString("baseUrl", _service.baseUrl);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            // a button that takes a picture
            MaterialButton(
              padding: EdgeInsets.all(20),
              child: Text(
                'Take A Picture',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Color(0xff004AAD),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(
                        image: image,
                        service: _service,
                      ),
                    ),
                  );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
