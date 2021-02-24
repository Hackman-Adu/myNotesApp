import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static int getColor(String colorCode) {
    return int.parse(colorCode.replaceAll("#", "0xff"));
  }

  static String formattedDate(String date) {
    return DateFormat('MMMM, dd yyyy hh:mm a').format(DateTime.parse(date));
  }

  static String defaultFontFamily() {
    return "OpenSans-Light";
  }

  static void showSnackBar(
      String message, GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text(message),
    ));
  }
}
