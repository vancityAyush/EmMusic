import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:camera/camera.dart';
import 'package:em_music/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondScreen extends StatefulWidget {
  final XFile image;
  Service service;
  SecondScreen({Key? key, required this.image, required this.service})
      : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var res;

  String? getEmoji(String emotion) {
    switch (emotion) {
      case "angry":
        return "😡";
      case "disgust":
        return "😫";
      case "fear":
        return "😨";
      case "happy":
        return "😃";
      case "neutral":
        return "😐";
      case "sad":
        return "😢";
      case "surprise":
        return "😮";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Em Music'),
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
                      widget.service.baseUrl = value;
                    },
                  ),
                  actions: [
                    FlatButton(
                      child: const Text('OK'),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString("baseUrl", widget.service.baseUrl);
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
      body: FutureBuilder(
          future: widget.service.getEmotion(widget.image),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              res = snapshot.data;
              return Container(
                decoration: const BoxDecoration(
                  color: const Color(0xff004AAD),
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage(
                      "assets/logo.png",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: BlurryContainer(
                      elevation: 4,
                      blur: 0.2,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            getEmoji(res["emotion"]) ?? "😐",
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            res["emotion"],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          getEmoji(res["emotion"]) == null
                              ? Text("Try Again",
                                  style: const TextStyle(fontSize: 20))
                              : MaterialButton(
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    launchUrl(Uri.parse(res["url"]));
                                  },
                                  child: const Text("Play Music"),
                                ),
                          const SizedBox(height: 40),
                          MaterialButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Retake Picture"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
