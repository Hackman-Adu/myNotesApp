import "package:flutter/material.dart";

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  double value = 0.1;
  List<String> selectedNames = [];
  List<String> names = [
    'Hackman Owusu Agyemang',
    'Adu Gyamfi',
    'Asante Emmanuel King',
    'Barnes Ebenezer',
    'Rosetta Mensah Appiah'
  ];
  String memberInitials(String name) {
    List<String> splitName = name.split(' ');
    String firstname = splitName[0];
    String lastname = splitName[splitName.length - 1];
    return firstname[0] + lastname[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).primaryColor.withOpacity(this.value),
          title: Text("Members"),
        ),
        body: ListView(
          children: [
            ...this.names.map((name) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                // color: Colors.yellowAccent,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        height: 50,
                        width: 50,
                        child: Center(
                          child: Text(
                            this.memberInitials(name).toUpperCase(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(name.toUpperCase()),
                      Spacer(),
                      Icon(Icons.add),
                      SizedBox(
                        width: 7,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "Current Value is ${this.value.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 21),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  trackHeight: 1,
                  thumbColor: Colors.redAccent,
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 16)),
              child: Slider(
                value: this.value,
                min: 0.0,
                max: 1,
                inactiveColor: Colors.white.withOpacity(0.65),
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                },
              ),
            )
          ],
        ));
  }
}
