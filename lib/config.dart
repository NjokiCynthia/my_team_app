class Config {
  static const APP_FLAVOR = String.fromEnvironment('flavor');

  static bool get isProd {
    String _s = 'Dev';
    if (APP_FLAVOR != "") _s = APP_FLAVOR.substring(APP_FLAVOR.length - 3);
    return (_s.toLowerCase() == "prod");
  }

  static String get appName {
    String _name = 'Chamasoft';
    String _flavor =
        APP_FLAVOR.substring(0, APP_FLAVOR.length - 3).toLowerCase();
    print("_flavor");
    switch (_flavor) {
      case 'eazzyclub':
        _name = "EazzyClub";
        break;
      case 'chamasoft':
        _name = "Chamasoft";
        break;
      case 'eazzykikundi':
        _name = "EazzyKikundi";
        break;
      case 'eazzychama':
        _name = "EazzyChama";
        break;
      default:
    }
    return _name;
  }
}
