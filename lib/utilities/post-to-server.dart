import 'package:simple_rsa/simple_rsa.dart';

class PostToServer {
  static _login(String password) async {
    try {
      final PUBLIC_KEY =
          "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+VsG3fDU1B8V7258pZST" +
              "0FfZzEXiPCC6i8RtA5pyS/orSBa1Ds3PMnF4qU+Z+HlBB9apKG/pYK73mXR8v1cX" +
              "jZCFxg08Gq/dwam1O5ehNXtEHKhembXdZC2zdFyVVg8emgbyDxaP1oEWwQOqoUI7" +
              "1e1lPqDMrFTUeS65YO2ayWeEKEnY12nE6pgyopSdEo5Boz4RzxCL8jLIhTwRouhi" +
              "MOA9UyWBYuQEp8P1yj8zVoB20WyB6qOazPIiCEUz4MK0/yiVTR6B8hWwQydvMGKu" +
              "QWdCjZcopnehZDPLyXc5fuC++4o6E6WfDoL/GCTMeQ/bCaavCKUX4oypMLUVN1Zd" +
              "3QIDAQAB";

      final encrypted = await encryptString(password, PUBLIC_KEY);
      return encrypted;
    } catch (e) {
      print("Error3 $e");
    }
  }

  static Future<void> post(String jsonObject) {
    _login(jsonObject);
  }
}
