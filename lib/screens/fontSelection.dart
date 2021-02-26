import 'package:flutter/material.dart';
import 'package:noteApp/models/fonts.dart';
import 'package:noteApp/util/utils.dart';

class SelectFont extends StatefulWidget {
  final String previousFontFamily;
  SelectFont({this.previousFontFamily});
  @override
  State<StatefulWidget> createState() {
    return SelectFontState(previousFontFamily: this.previousFontFamily);
  }
}

class SelectFontState extends State<SelectFont> {
  final String previousFontFamily;
  SelectFontState({this.previousFontFamily});
  List<CustomFonts> fonts = CustomFonts().getFonts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: Utils.getToolbarElevation(),
        title: Text("Select Font"),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10),
        itemCount: this.fonts.length,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          var font = this.fonts[index];
          return ListTile(
            trailing: this.previousFontFamily == font.family
                ? Container(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.greenAccent, shape: BoxShape.circle),
                  )
                : null,
            onTap: () {
              Navigator.of(context).pop(font.family);
            },
            title: Text(font.fontName),
            subtitle: Text(
              "Sample preview",
              style: TextStyle(fontSize: 30, fontFamily: font.family),
            ),
          );
        },
      ),
    );
  }
}
