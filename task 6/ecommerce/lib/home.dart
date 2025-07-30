import 'package:ecommerce/add.dart';
import 'package:ecommerce/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/card.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [Text("JULY 23"), Text("HI YUBI")],
              ),
              const SizedBox(width: 10),
              const Icon(Icons.notifications)
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("Available Product"), Icon(Icons.search)],
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Details()));
            },
            child:name(),),
          GestureDetector(
            onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (context) => const Details()));
            },
            child:name(),),
            GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Details()));
            },
            child:name(),),
          FloatingActionButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add()),
            );
          })
        ],
      ),
    );
  }
}
