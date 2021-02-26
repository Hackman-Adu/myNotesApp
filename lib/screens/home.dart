import 'dart:async' show Future, Timer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteApp/models/notes.dart';
import 'package:noteApp/screens/addNote.dart';
import 'package:noteApp/controllers/noteController.dart';
import 'package:noteApp/screens/editNote.dart';
import 'package:noteApp/screens/viewNote.dart';
import 'package:noteApp/util/utils.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //variables declaration
  List<Notes> notes = [];
  List<Notes> allNotes = [];
  List<Notes> selectedNotes = [];
  bool isAllNotesSelected = false;
  bool isLoading;
  var searchText = new TextEditingController();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationController;
  Animation<double> animation;
  CurvedAnimation curve;
  int selectedIndex = 0;

  //closing the application
  Future<bool> closingApplication(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            title: Text("Exit Application"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Do you want to close the application?"),
                SizedBox(height: 17),
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
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Yes"),
                    )),
                    SizedBox(width: 15),
                    Expanded(
                        child: FlatButton(
                      height: 50,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Color(0xff5AC18E),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("No"),
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

//confirming deleting notes
  Future<bool> deletingNotes(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
            title: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.redAccent, shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(this.selectedNotes.length > 1
                    ? "Delete Selected Notes"
                    : "Delete Note")
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(this.selectedNotes.length > 1
                    ? "Do you want to permanently delete the selected notes?"
                    : "Do you want to permanently delete this note?"),
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
                        Navigator.of(context).pop(true);
                      },
                      child: Text("Yes"),
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
                        Navigator.of(context).pop(false);
                      },
                      child: Text("No"),
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

//getting all notes
  void getAllNotes() {
    setState(() {
      this.isLoading = true;
    });
    NotesController().getNotes().then((notes) {
      Timer(Duration(milliseconds: 1000), () {
        setState(() {
          this.isLoading = false;
          this.notes = notes;
          this.allNotes = notes;
        });
      });
    }).catchError((err) {
      setState(() {
        this.isLoading = false;
      });
    });
  }

//attach animation to selection
  void setAnimation(Notes note) {
    this.selectedIndex == this.notes.indexOf(note)
        ? this.beginAnimation()
        : this.animationController.stop();
  }

//overriding the initState
  @override
  void initState() {
    this.animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    this.curve = new CurvedAnimation(
        curve: Curves.easeIn, parent: this.animationController);
    this.animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    this.animationController.addListener(() {
      setState(() {});
    });
    super.initState();
    this.getAllNotes();
  }

//initiate animation
  void beginAnimation() {
    this.animationController.reset();
    this.animationController.forward();
  }

//function to get added Note
  void getAddedNote() async {
    Notes newNote = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewNote()));
    setState(() {
      if (newNote.title.trim() != '' || newNote.title != null) {
        this.notes.insert(0, newNote);
        Utils.showSnackBar("New Note successfully added", scaffoldKey);
      }
    });
  }

//function to return action buttons
  List<Widget> actionButons() {
    return [
      this.selectedNotes.length == 0
          ? IconButton(
              splashRadius: 17,
              onPressed: () {
                this.getAllNotes();
              },
              icon: Icon(Icons.refresh))
          : Text(''),
      this.selectedNotes.length == 0
          ? IconButton(
              splashRadius: 17,
              onPressed: () {
                //sharing of the uploaded link
              },
              icon: Icon(Icons.share),
            )
          : Text(''),
      this.selectedNotes.length == 1
          ? IconButton(
              onPressed: () {
                var note = this.selectedNotes[0];
                var contentToShare = note.title +
                    '\n' +
                    'Note Taken On: ${Utils.formattedDate(note.noteDate)}\n' +
                    note.content;
                Share.share(contentToShare, subject: contentToShare);
              },
              icon: Icon(Icons.share))
          : Text(''),
      this.selectedNotes.length > 0
          ? IconButton(
              onPressed: () async {
                bool yesNo = await this.deletingNotes(context);
                if (this.selectedNotes.length == 1) {
                  if (yesNo == true) {
                    NotesController()
                        .deleteNote(this.selectedNotes[0].noteID)
                        .then((value) {
                      setState(() {
                        this.notes.remove(this.selectedNotes[0]);
                        this.selectedNotes.clear();
                        Utils.showSnackBar(
                            "Note successfully deleted", scaffoldKey);
                      });
                    });
                  }
                } else {
                  if (yesNo == true) {
                    selectedNotes.forEach((note) {
                      NotesController().deleteNote(note.noteID).then((value) {
                        setState(() {
                          this.notes.remove(note);
                          this.selectedNotes.remove(note);
                        });
                      }).catchError((err) {
                        Utils.showSnackBar(
                            "Failed to delete some notes", scaffoldKey);
                      });
                    });
                    Utils.showSnackBar(
                        "Notes successfully deleted", scaffoldKey);
                  }
                }
              },
              icon: Icon(Icons.delete),
            )
          : Text(''),
      this.selectedNotes.length == 1
          ? IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNote(
                              noteToEdit: this.selectedNotes[0],
                              location: "Home",
                            )));
              },
              icon: Icon(Icons.edit),
            )
          : Text(''),
      this.selectedNotes.length == 1
          ? IconButton(
              onPressed: () async {
                ClipboardData data = new ClipboardData(
                    text: selectedNotes[0].title +
                        '\n' +
                        Utils.formattedDate(selectedNotes[0].noteDate) +
                        '\n' +
                        selectedNotes[0].content);
                await Clipboard.setData(data).then((value) {
                  Utils.showSnackBar(
                      "Contents successfully copied to clipboard", scaffoldKey);
                });
              },
              icon: Icon(Icons.copy),
            )
          : Text('')
    ];
  }

//function to override leading widget
  Widget leading() {
    return IconButton(
        onPressed: () {
          setState(() {
            this.selectedNotes.clear();
          });
        },
        icon: Utils.backIcon());
  }

//build searchBar widget
  Widget searchBar() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 25,
          shadowColor: Colors.black.withOpacity(0.25),
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 7,
                  ),
                  Icon(Icons.search, color: Theme.of(context).primaryColor),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(
                      child: TextFormField(
                    controller: this.searchText,
                    onChanged: (value) {
                      setState(() {
                        if (value.trim() == '') {
                          this.notes = this.allNotes;
                        } else {
                          this.notes = this.allNotes.where((note) {
                            return note.title
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                note.content
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                    style: TextStyle(
                        fontSize: 17, color: Theme.of(context).primaryColor),
                    decoration: InputDecoration(
                        hintText: "Search notes here",
                        hintStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    splashRadius: 17,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      this.searchText.text = "";
                      setState(() {
                        this.notes = this.allNotes;
                      });
                    },
                    icon: Icon(Icons.cancel),
                  )
                ],
              )),
        ));
  }

//build select all widget
  Widget selectAll() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              "Select All",
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
            SizedBox(
              width: 17,
            ),
            Utils.checkBox(this.isAllNotesSelected, (value) {
              setState(() {
                this.isAllNotesSelected = value;
                if (isAllNotesSelected) {
                  this.selectedNotes = [...this.notes];
                } else {
                  this.selectedNotes = [];
                }
              });
            })
          ],
        ));
  }

//overriding the build method from the State
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (this.selectedNotes.length > 0) {
            setState(() {
              this.selectedNotes.clear();
            });
            return false;
          } else {
            return this.closingApplication(context);
          }
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            key: this.scaffoldKey,
            appBar: AppBar(
                elevation: Utils.getToolbarElevation(),
                leading: this.selectedNotes.length > 0 ? this.leading() : null,
                title: Text(this.selectedNotes.length == 0
                    ? "My Notes"
                    : "${this.selectedNotes.length} Selected"),
                actions: this.actionButons()),
            floatingActionButton: FloatingActionButton.extended(
              label: Row(
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text("Add New Note")
                ],
              ),
              backgroundColor: Color(0xff5AC18E),
              onPressed: () async {
                this.getAddedNote();
              },
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      this.searchBar(),
                      this.isLoading == false
                          ? this.notes.length > 0
                              ? ListView(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    this.selectedNotes.length > 0
                                        ? this.selectAll()
                                        : Text(''),
                                    ...this.notes.map((note) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            onLongPress: () {
                                              setState(() {
                                                this.selectedIndex =
                                                    this.notes.indexOf(note);
                                                if (this.selectedNotes.length ==
                                                    0) {
                                                  this.setAnimation(note);
                                                  this.selectedNotes.add(note);
                                                  isAllNotesSelected = false;
                                                }
                                              });
                                            },
                                            onTap: () {
                                              setState(() {
                                                this.selectedIndex =
                                                    this.notes.indexOf(note);
                                                if (this.selectedNotes.length >
                                                        0 &&
                                                    this
                                                        .selectedNotes
                                                        .contains(note)) {
                                                  this
                                                      .selectedNotes
                                                      .remove(note);
                                                  isAllNotesSelected = false;
                                                } else if (this
                                                        .selectedNotes
                                                        .length >
                                                    0) {
                                                  this.setAnimation(note);
                                                  this.selectedNotes.add(note);
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewNote(
                                                                selectedNote:
                                                                    note,
                                                              )));
                                                }
                                              });
                                            },
                                            leading: !this
                                                    .selectedNotes
                                                    .contains(note)
                                                ? Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Center(
                                                      child: Text(
                                                          note.title[0]
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: note.titleColor ==
                                                                          "#f5f5f5" ||
                                                                      note.titleColor ==
                                                                          "#FFFFFF"
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 21)),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Color(
                                                            Utils.getColor(note
                                                                .titleColor)),
                                                        shape: BoxShape.circle),
                                                  )
                                                : ScaleTransition(
                                                    scale: this.selectedIndex ==
                                                            this
                                                                .notes
                                                                .indexOf(note)
                                                        ? this.animation
                                                        : Tween<double>(
                                                                begin: 1.0,
                                                                end: 1.0)
                                                            .animate(
                                                                this.curve),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Color(Utils
                                                              .getColor(note
                                                                  .titleColor)),
                                                          shape:
                                                              BoxShape.circle),
                                                      height: 35,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 17,
                                                          color:
                                                              note.titleColor ==
                                                                      "#f5f5f5"
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                        ),
                                                      ),
                                                      width: 35,
                                                    )),
                                            trailing: Icon(Icons.chevron_right),
                                            subtitle: Text(
                                                Utils.formattedDate(
                                                    note.noteDate),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xff5AC18E)
                                                        .withOpacity(0.95))),
                                            title: Text(
                                                note.title.toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(Utils.getColor(
                                                            note.titleColor))
                                                        .withOpacity(0.85))),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Divider(),
                                          )
                                        ],
                                      );
                                    }).toList(),
                                    SizedBox(
                                      height: 27,
                                    ),
                                    Center(
                                        child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        this.notes.length > 1
                                            ? "${this.notes.length} Notes Available"
                                            : "${this.notes.length} Note Available",
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ))
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Text(
                                      "Nothing found",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ))
                          : Padding(
                              padding: EdgeInsets.only(top: 45),
                              child: Center(child: Utils.showPinnerDialog()))
                    ],
                  ),
                ))));
  }
}
