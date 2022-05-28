import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:camera/camera.dart';
import 'package:em_music/service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondScreen extends StatefulWidget {
  final XFile image;
  const SecondScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final _service = Service(
      "https://3aeb-2409-4052-2e1a-d52a-ad09-b112-cf14-8cce.in.ngrok.io");
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
      ),
      body: FutureBuilder(
          future: _service.getEmotion(widget.image),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              res = snapshot.data;
              return Container(
                decoration: const BoxDecoration(
                  color: const Color(0xff004AAD),
                  image: const DecorationImage(
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
