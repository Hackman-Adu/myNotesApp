import 'package:flutter/material.dart';
import 'package:noteApp/models/colors.dart';
import 'package:noteApp/models/notes.dart';
import 'package:noteApp/controllers/noteController.dart';
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
  NoteColors selectedColor;
  double fontSize = 20.0;
  Notes note = new Notes();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

//saving the note to the SQLite Database
  void saveNote() {
    if (this.formKey.currentState.validate()) {
      print(this.getNoteDate());
      this.formKey.currentState.save();
      this.note.noteID = this.getNoteID();
      this.note.noteDate = this.getNoteDate();
      this.note.titleColor = this.titleColor;
      this.note.titleFontSize = int.parse(this.fontSize.round().toString());
      NotesController().insertNote(this.note).then((value) {
        Utils.showSnackBar("Note successfully saved", this.scaffoldKey);
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

//alert user on unsaved note when leaving the page
  Future<bool> saveNotBeforeLeavingPage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Note Not Saved"),
            content: Text("Do you want to save this note?"),
            actions: [
              FlatButton(
                onPressed: () {
                  NotesController().insertNote(note).then((value) {
                    Navigator.of(context).pop(true);
                  });
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  this.note.title = '';
                  Navigator.of(context).pop(true);
                },
                child: Text("No,leave page"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        });
  }

//showing the change font size dialog alert
  Future<double> changeFontSize(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          double fSize = 20.0;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  "Change Font Size",
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: this.fontSize,
                      min: 20.0,
                      max: 50,
                      onChanged: (value) {
                        setState(() {
                          this.setState(() {
                            this.fontSize = value;
                          });
                        });
                      },
                    )
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(this.fontSize);
                      },
                      child: Text("Okay")),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(fSize);
                      },
                      child: Text("Default"))
                ],
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
                title: Text(
                  "Change Font Color",
                  style: TextStyle(
                      color:
                          Color(Utils.getColor(this.selectedColor.colorCodes))),
                ),
                content: Container(
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
                              child: selectedIndex == this.colors.indexOf(color)
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : Text(''),
                            ),
                            decoration: BoxDecoration(
                                color: Color(Utils.getColor(color.colorCodes)),
                                shape: BoxShape.circle),
                          ));
                    }).toList(),
                  ),
                ),
              );
            },
          );
        });
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
        key: this.scaffoldKey,
        appBar: AppBar(
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
                    elevation: 25,
                    shadowColor: Colors.black.withOpacity(0.5),
                    child: Form(
                      key: this.formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            color: Color(0xff5AC18E),
                            width: double.infinity,
                            child: Row(
                              children: [
                                IconButton(
                                  splashRadius: 17,
                                  onPressed: () async {
                                    var v = await this.changeFontSize(context);
                                    setState(() {
                                      this.fontSize = v;
                                    });
                                  },
                                  icon: Icon(Icons.text_fields),
                                ),
                                Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Text(
                                        this.fontSize.round().toString(),
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  splashRadius: 17,
                                  onPressed: () {
                                    this.changeFontColor(context);
                                  },
                                  icon: Icon(Icons.format_color_fill),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, right: 20, left: 20, top: 20),
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
                                    color: this.textColor),
                                decoration: InputDecoration(
                                    labelText: "Note title",
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.85)),
                                    hintText: "Note title"),
                              )),
                          SizedBox(
                            height: 43,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, right: 20, left: 20),
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
                                maxLength: 500,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.85)),
                                decoration: InputDecoration(
                                    labelText: "Note content",
                                    labelStyle: TextStyle(
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
