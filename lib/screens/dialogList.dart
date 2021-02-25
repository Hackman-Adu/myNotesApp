import 'package:flutter/material.dart';
import 'package:noteApp/models/fonts.dart';

class DialogList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DialogListState();
  }
}

class DialogListState extends State<DialogList> {
  List<CustomFonts> fonts = CustomFonts().getFonts();
  String selectedFont = "Choose Font";
  List<CustomFonts> allfonts = CustomFonts().getFonts();

  showListDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                title: Text("Choose Font"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            this.setState(() {
                              if (value.trim() == '') {
                                this.fonts = this.allfonts;
                              } else {
                                this.fonts = this.allfonts.where((font) {
                                  return font.family
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                }).toList();
                              }
                            });
                          });
                        },
                        decoration: InputDecoration(hintText: "Search Font"),
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      ...this.fonts.map((font) {
                        return Container(
                          child: ListTile(
                              subtitle: Padding(
                                padding: EdgeInsets.only(left: 17),
                                child: Text(
                                  "Sample here",
                                  style: TextStyle(fontFamily: font.family),
                                ),
                              ),
                              onTap: () {
                                this.setState(() {
                                  this.selectedFont = font.family;
                                  Navigator.pop(context);
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding: EdgeInsets.only(left: 17),
                                child: Text(font.family),
                              )),
                        );
                      }).toList()
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose Font"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: FlatButton(
              height: 50,
              minWidth: double.infinity,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              onPressed: () {
                this.showListDialog(context);
                setState(() {
                  this.fonts = this.allfonts;
                });
              },
              child: Text(this.selectedFont),
              color: Colors.redAccent,
            ),
          ),
        ));
  }
}
