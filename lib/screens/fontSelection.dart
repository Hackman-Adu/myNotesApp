import 'package:flutter/material.dart';
import 'package:noteApp/models/fonts.dart';

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
      appBar: AppBar(
        title: Text("Select Font"),
      ),
      body: ListView(
        children: [
          ...this.fonts.map((font) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
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
                              color: Colors.greenAccent,
                              shape: BoxShape.circle),
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
                ));
          }).toList()
        ],
      ),
    );
  }
}
