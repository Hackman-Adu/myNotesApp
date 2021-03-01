import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteApp/models/colors.dart';
import 'package:noteApp/models/contentColors.dart';
import 'package:noteApp/models/notes.dart';
import 'package:noteApp/controllers/noteController.dart';
import 'package:noteApp/screens/fontSelection.dart';
import 'package:noteApp/screens/selectContentColor.dart';
import "package:noteApp/util/utils.dart";

class AddNewNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddNewNoteState();
  }
}

class AddNewNoteState extends State<AddNewNote> {
  //declaring variables
  List<NoteColors> colors = NoteColors().getColors();
  Color textColor;
  String titleColor = "";
  String contentColor = "#ffffff";
  String selectedFontFamily = Utils.getDefaultFont();
  NoteColors selectedColor;
  double fontSize = 20.0;
  double contentFontSize = 21.0;
  Notes note = new Notes();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isContentBold = false;
  bool isContentItalic = false;

//saving the note to the SQLite Database
  void saveNote() {
    if (this.formKey.currentState.validate()) {
      this.formKey.currentState.save();
      this.note.contentItalic = this.isContentItalic ? "true" : "false";
      this.note.contentBold = this.isContentBold ? "true" : "false";
      this.note.contentFont = this.selectedFontFamily;
      this.note.noteID = this.getNoteID();
      this.note.noteDate = this.getNoteDate();
      this.note.titleColor = this.titleColor;
      this.note.contentColor = this.contentColor;
      this.note.titleFontSize = int.parse(this.fontSize.round().toString());
      this.note.contentFontSize =
          int.parse(this.contentFontSize.round().toString());
      NotesController().insertNote(this.note).then((value) {
        Navigator.of(context).pop(this.note);
      }).catchError((err) {
        Utils.showSnackBar(
            "Failed to save this note. Try again", this.scaffoldKey);
      });
    }
  }

//function to generate unique ID for the NoteID
  int getNoteID() {
    var now = DateTime.now().millisecondsSinceEpoch;
    return now;
  }

//function to get the current the date
  String getNoteDate() {
    var date = DateTime.now();
    return date.toString();
  }

//showing the change font size dialog alert
  Future<double> changeFontSize(BuildContext context, String applTo) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          double fSize = 20.0;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17)),
                title: Center(
                    child: Text(
                  "Change Font Size",
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Utils.showSlider(
                      applTo == "title" ? this.fontSize : this.contentFontSize,
                      (value) {
                        setState(() {
                          this.setState(() {
                            if (applTo == "title") {
                              this.fontSize = value;
                            } else {
                              this.contentFontSize = value;
                            }
                          });
                        });
                      },
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                          height: 50,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color(0xff5AC18E),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop(applTo == "title"
                                ? this.fontSize
                                : this.contentFontSize);
                          },
                          child: Text("Okay"),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: FlatButton(
                          height: 50,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color(0xff5AC18E),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop(fSize);
                          },
                          child: Text("Default"),
                        )),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        });
  }

//showing the change font color dialog alert
  Future<double> changeFontColor(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          int selectedIndex = this.colors.indexOf(this.selectedColor);
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Text(
                    "Change Font Color",
                    style: TextStyle(
                        color: Color(
                            Utils.getColor(this.selectedColor.colorCodes))),
                  ),
                  content: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      child: Wrap(
                        runSpacing: 13,
                        spacing: 13,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: this.colors.map((color) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = this.colors.indexOf(color);
                                  this.setState(() {
                                    this.titleColor = color.colorCodes;
                                    this.selectedColor = color;
                                    this.textColor =
                                        Color(Utils.getColor(color.colorCodes));
                                  });
                                });
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: selectedIndex ==
                                          this.colors.indexOf(color)
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : Text(''),
                                ),
                                decoration: BoxDecoration(
                                    color:
                                        Color(Utils.getColor(color.colorCodes)),
                                    shape: BoxShape.circle),
                              ));
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Center(
                      child: FlatButton(
                        height: 50,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Color(0xff5AC18E),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Okay"),
                      ),
                    )
                  ])));
            },
          );
        });
  }

//build formatting toolbar
  Widget titleFormattingToolBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Color(0xff5AC18E),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 7,
          ),
          Utils.toolbarIcons(Icons.text_fields, () async {
            var v = await this.changeFontSize(context, "title");
            setState(() {
              this.fontSize = v;
            });
          }, context),
          SizedBox(
            width: 10,
          ),
          Utils.smallContainerForFontSize(context, this.fontSize),
          SizedBox(width: 25),
          Utils.toolbarIcons(Icons.format_color_fill, () {
            this.changeFontColor(context);
          }, context)
        ],
      ),
    );
  }

//build contentToolBar

  Widget contentToolBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Color(0xff5AC18E),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 7,
          ),
          Utils.toolbarIcons(Icons.text_format, () async {
            var family = await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => SelectFont(
                          previousFontFamily: this.selectedFontFamily,
                        )));
            setState(() {
              this.selectedFontFamily = family ?? Utils.getDefaultFont();
            });
          }, context),
          SizedBox(
            width: 17,
          ),
          Utils.formattingContentToolbar(Icons.format_italic, () {
            setState(() {
              this.isContentItalic = !this.isContentItalic;
            });
          }, context,
              boxColor: this.isContentItalic
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              iconColor: this.isContentItalic
                  ? Colors.white
                  : Theme.of(context).primaryColor),
          SizedBox(
            width: 17,
          ),
          Utils.formattingContentToolbar(Icons.format_bold, () {
            setState(() {
              this.isContentBold = !this.isContentBold;
            });
          }, context,
              boxColor: this.isContentBold
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              iconColor: this.isContentBold
                  ? Colors.white
                  : Theme.of(context).primaryColor),
          SizedBox(
            width: 17,
          ),
          Utils.toolbarIcons(Icons.text_fields, () async {
            var v = await this.changeFontSize(context, "content");
            setState(() {
              this.contentFontSize = v;
            });
          }, context),
          SizedBox(
            width: 7,
          ),
          Utils.smallContainerForFontSize(context, this.contentFontSize),
          Expanded(
              child: Utils.toolbarIcons(Icons.format_color_fill, () async {
            ContentColors selectedColor = await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => SelectContentColor(
                          initialColor: this.contentColor,
                        )));
            setState(() {
              this.contentColor = selectedColor.colorCodes;
            });
          }, context))
        ],
      ),
    );
  }

//overriding the initState method from the State
  @override
  void initState() {
    super.initState();
    this.textColor = Color(Utils.getColor(this.colors[0].colorCodes));
    this.selectedColor = this.colors[0];
    this.titleColor = this.colors[0].colorCodes;
  }

  ///overriding the build method from the State
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: this.scaffoldKey,
        appBar: AppBar(
          elevation: Utils.getToolbarElevation(),
          title: Text("Add New Note"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 2.5,
                    color: Theme.of(context).primaryColor,
                    shadowColor: Colors.white.withOpacity(0.25),
                    child: Form(
                      key: this.formKey,
                      child: Column(
                        children: [
                          this.titleFormattingToolBar(),
                          SizedBox(
                            height: 17,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: TextFormField(
                                maxLines: null,
                                maxLength: 30,
                                keyboardType: TextInputType.multiline,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (value) {
                                  this.note.title = value;
                                },
                                validator: (value) {
                                  if (value.trim() == '') {
                                    return "Note title is required";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                    fontSize: this.fontSize,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Utils.getDefaultFont(),
                                    color: this.textColor),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    labelText: "Note title",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.85)),
                                    hintText: "Note title"),
                              )),
                          SizedBox(
                            height: 43,
                          ),
                          this.contentToolBar(),
                          SizedBox(
                            height: 17,
                          ),
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (value) {
                                  this.note.content = value;
                                },
                                validator: (value) {
                                  if (value.trim() == '') {
                                    return "Note content is required";
                                  } else {
                                    return null;
                                  }
                                },
                                maxLength: 1500,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                    fontStyle: this.isContentItalic
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    fontWeight: this.isContentBold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: this.contentFontSize,
                                    fontFamily: this.selectedFontFamily,
                                    color: Color(
                                        Utils.getColor(this.contentColor))),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    labelText: "Note content",
                                    labelStyle: TextStyle(
                                        fontFamily: Utils.getDefaultFont(),
                                        color: Colors.white.withOpacity(0.85)),
                                    hintText: "Note content"),
                              )),
                          SizedBox(
                            height: 43,
                          ),
                          FlatButton(
                            onPressed: () {
                              this.saveNote();
                            },
                            color: Color(0xff00ced1),
                            minWidth: double.infinity,
                            height: 50,
                            textColor: Colors.white,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Save Note")
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
