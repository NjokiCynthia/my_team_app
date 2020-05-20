class CustomHelper {
  static const String baseUrl = "https://uat.chamasoft.com/";
  static const String generatePin = "mobile/generate_pin";

  static bool validPhone(String phone) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(phone))
      return true;
    else
      return false;
  }

  static bool validEmail(String email) {
    Pattern pattern =r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email))
      return true;
    else
      return false;
  }

  static bool validIdentity(String identity){
    return validEmail(identity)||validPhone(identity);
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message.toString();
  }
}
