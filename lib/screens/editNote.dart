import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteApp/controllers/noteController.dart';
import 'package:noteApp/models/colors.dart';
import 'package:noteApp/models/contentColors.dart';
import 'package:noteApp/models/notes.dart';
import 'package:noteApp/screens/selectContentColor.dart';
import 'package:noteApp/util/utils.dart';

import 'fontSelection.dart';

class EditNote extends StatefulWidget {
  final Notes noteToEdit;
  final String location;
  EditNote({this.noteToEdit, @required this.location});
  @override
  State<StatefulWidget> createState() {
    return EditNoteState(noteToEdit: this.noteToEdit, location: this.location);
  }
}

class EditNoteState extends State<EditNote> {
  //declaring variables
  List<NoteColors> colors = NoteColors().getColors();
  final Notes noteToEdit;
  final String location;
  EditNoteState({this.noteToEdit, @required this.location});
  var noteTitle;
  var noteContent;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var formKey = new GlobalKey<FormState>();
  double fontSize;
  double contentfontSize;
  Color textColor;
  String selectedFontFamily;
  String titleColor = "";
  String contentColor;
  NoteColors selectedColor;
  bool isContentBold;
  bool isContentItalic;

//function to change fontsize
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
                      applTo == "title" ? this.fontSize : this.contentfontSize,
                      (value) {
                        setState(() {
                          this.setState(() {
                            if (applTo == "title") {
                              this.fontSize = value;
                            } else {
                              this.contentfontSize = value;
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
                                : this.contentfontSize);
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

//function to change fontColor
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

//function to update the note
  void updateNote() {
    if (this.formKey.currentState.validate()) {
      this.formKey.currentState.save();
      this.noteToEdit.content = this.noteContent.text;
      this.noteToEdit.title = this.noteTitle.text;
      this.noteToEdit.titleColor = this.titleColor;
      this.noteToEdit.contentColor = this.contentColor;
      this.noteToEdit.contentItalic = this.isContentItalic ? "true" : "false";
      this.noteToEdit.contentBold = this.isContentBold ? "true" : "false";
      this.noteToEdit.contentFont = this.selectedFontFamily;
      this.noteToEdit.titleFontSize =
          int.parse(this.fontSize.round().toString());
      this.noteToEdit.contentFontSize =
          int.parse(this.contentfontSize.round().toString());
      NotesController()
          .updateNote(this.noteToEdit.noteID, this.noteToEdit)
          .then((value) {
        if (this.location == "View Note") {
          Navigator.of(context).pop(this.noteToEdit);
        } else {
          Utils.showSnackBar("Note successfully updated", scaffoldKey);
        }
      }).catchError((err) {
        Utils.showSnackBar(
            "Failed to update this note. Try again", this.scaffoldKey);
      });
    }
  }

//build formatting---content toolbar
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
              this.contentfontSize = v;
            });
          }, context),
          SizedBox(
            width: 7,
          ),
          Utils.smallContainerForFontSize(context, this.contentfontSize),
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
            width: 7,
          ),
          Utils.smallContainerForFontSize(context, this.fontSize),
          SizedBox(
            width: 25,
          ),
          Utils.toolbarIcons(Icons.format_color_fill, () {
            this.changeFontColor(context);
          }, context)
        ],
      ),
    );
  }

//overriding the init state
  @override
  void initState() {
    super.initState();
    this.selectedFontFamily = this.noteToEdit.contentFont;
    this.selectedColor = this.colors[this
        .colors
        .indexWhere((note) => note.colorCodes == this.noteToEdit.titleColor)];
    this.titleColor = this.noteToEdit.titleColor;
    this.contentColor = this.noteToEdit.contentColor;
    this.textColor = Color(Utils.getColor(this.noteToEdit.titleColor));
    this.isContentBold = this.noteToEdit.contentBold == "true" ? true : false;
    this.isContentItalic =
        this.noteToEdit.contentItalic == "true" ? true : false;
    this.fontSize = double.parse(this.noteToEdit.titleFontSize.toString());
    this.contentfontSize =
        double.parse(this.noteToEdit.contentFontSize.toString());
    this.noteTitle = new TextEditingController(text: this.noteToEdit.title);
    this.noteContent = new TextEditingController(text: this.noteToEdit.content);
  }

//overriding the build method from the state class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: this.scaffoldKey,
        appBar: AppBar(
          elevation: Utils.getToolbarElevation(),
          title: Text("Edit Note"),
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
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                controller: this.noteTitle,
                                maxLines: null,
                                maxLength: 30,
                                keyboardType: TextInputType.multiline,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value.trim() == '') {
                                    return "Note title is required";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                    fontSize: this.fontSize,
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
                                controller: this.noteContent,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                    fontSize: this.contentfontSize,
                                    fontStyle: this.isContentItalic
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    fontWeight: this.isContentBold
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontFamily: selectedFontFamily,
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
                              this.updateNote();
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
                                  Text("Save Changes")
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
