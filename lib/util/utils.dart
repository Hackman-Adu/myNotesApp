import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class Utils {
  static int getColor(String colorCode) {
    return int.parse(colorCode.replaceAll("#", "0xff"));
  }

  static String formattedDate(String date) {
    return DateFormat('MMMM, dd yyyy hh:mm a').format(DateTime.parse(date));
  }

  static double getToolbarElevation() {
    return Platform.isAndroid ? 4 : 0;
  }

  static String defaultFontFamily() {
    return "Manjari-Thin";
  }

  static Widget backIcon() {
    var androidicon = Icon(Icons.arrow_back);
    var iosIcon = Icon(CupertinoIcons.back);
    var backIcon = Platform.isAndroid ? androidicon : iosIcon;
    return backIcon;
  }

  static Widget toolbarIcons(
    IconData icon,
    function,
    BuildContext context,
  ) {
    return GestureDetector(
        onTap: function,
        child: Container(
          height: 35,
          width: 35,
          decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(
            child: Icon(
              icon,
              size: 17,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ));
  }

  static Widget formattingContentToolbar(
      IconData icon, function, BuildContext context,
      {@required Color boxColor, @required iconColor}) {
    return GestureDetector(
        onTap: function,
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(color: boxColor, shape: BoxShape.circle),
          child: Center(
            child: Icon(icon, size: 17, color: iconColor),
          ),
        ));
  }

  static Widget showPinnerDialog() {
    var androidSpinner = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    );

    var iOSSpinner = CupertinoActivityIndicator(
      radius: 15,
    );
    var spinner = Platform.isAndroid ? androidSpinner : iOSSpinner;
    return spinner;
  }

  static Widget showSlider(value, function) {
    var androidSlider = Slider(
      value: value,
      onChanged: function,
      min: 20.0,
      max: 50.0,
    );
    var iOSSlider = CupertinoSlider(
      value: value,
      onChanged: function,
      min: 20.0,
      max: 50.0,
    );
    var slider = Platform.isAndroid ? androidSlider : iOSSlider;
    return slider;
  }

  static Widget checkBox(value, function) {
    var androidCheckbox = Checkbox(
      onChanged: function,
      value: value,
    );
    var iOSCheckbox = CupertinoSwitch(
      activeColor: Color(0xff5AC18E),
      value: value,
      onChanged: function,
    );
    var checkbox = Platform.isAndroid ? androidCheckbox : iOSCheckbox;
    return checkbox;
  }

  static Widget smallContainerForFontSize(BuildContext context, size) {
    return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor, shape: BoxShape.circle),
        child: Center(
          child: Text(
            size.round().toString(),
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        ));
  }

  static void showSnackBar(
      String message, GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text(message),
    ));
  }
}
