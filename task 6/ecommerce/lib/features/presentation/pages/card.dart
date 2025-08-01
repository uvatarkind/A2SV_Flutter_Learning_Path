import 'package:flutter/material.dart';

class name extends StatelessWidget {
  const name({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        height: 150,
        color: Colors.grey,
        child: Column(
          children: [
            Image.network(
              "https://images.app.goo.gl/n49tgdUvAGBj5BNU6",
              fit: BoxFit.cover,
              width: 280,
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Derby Leather Shoes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text("200 Bir")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Men's shoes",
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                    )),
                Row(children: [
                  Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  ),
                  Text("4.0")
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
