import 'package:flutter/material.dart';
import 'package:task4/learn_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return const LearnFlutter();
              },
              ),
            );
          },
          child: Text("Learn Flutter")),
    );
  }
}
