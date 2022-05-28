import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

class Service {
  String baseUrl;
  final Dio dio = Dio();
  Service(this.baseUrl);

  Future<dynamic> getEmotion(XFile image) async {
    try {
      final FormData form = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(image.path, filename: 'image.jpg'),
      });
      final response = await dio.post(
          "https://3aeb-2409-4052-2e1a-d52a-ad09-b112-cf14-8cce.in.ngrok.io/KambMusic/getTrack",
          data: form);
      print(response.data);
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
