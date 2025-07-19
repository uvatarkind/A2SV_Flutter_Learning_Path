import 'package:flutter/material.dart';

class LearnFlutter extends StatefulWidget {
  const LearnFlutter({super.key});

  @override
  State<LearnFlutter> createState() => _LearnFlutterState();
}

class _LearnFlutterState extends State<LearnFlutter> {
  bool isSwitch = false;
  bool isCheckbox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn Flutter"),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Image.asset('image/pic.jpg'),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.blueGrey,
            child: Text(
              "this is text ",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: isSwitch ? Colors.green : Colors.blue,
            ),
            onPressed: () {
              debugPrint("Elevated button");
            },
            child: Text("elevated button"),
          ),
          OutlinedButton(z
            onPressed: () {
              debugPrint("Elevated button");
            },
            child: Text("elevated button"),
          ),
          GestureDetector(
            onTap: () {
              debugPrint("Text Button");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.local_fire_department),
                Icon(
                  Icons.local_fire_department,
                  color: Colors.blue,
                )
              ],
            ),
          ),
          Switch(
              value: isSwitch,
              onChanged: (bool newBool) {
                setState(() {
                  isSwitch = newBool;
                });
              }),
          Checkbox(value: isCheckbox, onChanged: (bool ?newBool){
            setState(() {
              isCheckbox =newBool!;
            });
          })
        ],
      ),
    );
  }
}
