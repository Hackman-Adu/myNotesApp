import 'package:flutter/material.dart';
import 'package:noteApp/models/contentColors.dart';
import 'package:noteApp/util/utils.dart';

class SelectContentColor extends StatefulWidget {
  final String initialColor;
  SelectContentColor({this.initialColor});
  @override
  State<StatefulWidget> createState() {
    return SelectContentColorState(initialColor: this.initialColor);
  }
}

class SelectContentColorState extends State<SelectContentColor> {
  final String initialColor;
  SelectContentColorState({this.initialColor});
  List<ContentColors> colors = ContentColors().getColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: Utils.getToolbarElevation(),
        title: Text("Select Color"),
      ),
      body: ListView(
        children: [
          ...this.colors.map((color) {
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop(color);
                  },
                  trailing: color.colorCodes == this.initialColor
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                  title: Text(color.colorName),
                  leading: CircleAvatar(
                    backgroundColor: Color(Utils.getColor(color.colorCodes)),
                  ),
                ));
          }).toList()
        ],
      ),
    );
  }
}
