import 'package:flutter/material.dart';
import 'package:noteApp/models/notes.dart';
import 'package:noteApp/screens/editNote.dart';
import 'package:noteApp/util/utils.dart';

class ViewNote extends StatefulWidget {
  final Notes selectedNote;
  ViewNote({this.selectedNote});
  @override
  State<StatefulWidget> createState() {
    return ViewNoteState(selectedNote: this.selectedNote);
  }
}

class ViewNoteState extends State<ViewNote> {
  Notes selectedNote;
  ViewNoteState({this.selectedNote});
  var scaffoldKey = new GlobalKey<ScaffoldState>();

  TextStyle getStyleFromNote() {
    return TextStyle(
        color: Color(Utils.getColor(selectedNote.titleColor)),
        fontSize: double.parse(this.selectedNote.titleFontSize.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this.scaffoldKey,
        appBar: AppBar(
          title: Text("View Note"),
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () async {
                Notes editedNote = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNote(
                              noteToEdit: this.selectedNote,
                              location: "View Note",
                            )));
                setState(() {
                  if (editedNote.title != null) {
                    this.selectedNote = editedNote;
                  }
                  Utils.showSnackBar("Note successfully updated", scaffoldKey);
                });
              },
              icon: Icon(Icons.edit),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              ListTile(
                  isThreeLine: true,
                  subtitle: Text(selectedNote.content,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: selectedNote.contentFont ??
                              Utils.defaultFontFamily())),
                  title: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.selectedNote.title.toUpperCase(),
                          style: this.getStyleFromNote(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          Utils.formattedDate(selectedNote.noteDate),
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Divider(),
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
