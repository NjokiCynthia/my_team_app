class StatusHandler {
  void processResponse() {
    int status = 0;

    switch (status) {
      case 0:
        //handle validation and other generic errors
        //display error(s)
        break;
      case 1:
        //request successful
        break;
      case 2:
      case 3:
        //generic error
        //display error
        break;
      case 4:
      case 8:
      case 9:
        //reset app
        break;
      case 5:
      case 6:
      case 10:
        //clear current group loaded to preferences
        //clear screens and restart app from splash screen
        break;
      case 7:
        //generic error
        //display error
        break;
      case 11:
      case 13:
        //invalid request id or format
        break;
      case 12:
        //duplicate request submitted
        //treat as case 1
        //notify user of duplicates

        break;
      case 400:
        //log out user
        break;
      case 404:
        //generic error
        //display error
        break;
      default:
        //generic error
        //display error
        break;
    }
  }
}
