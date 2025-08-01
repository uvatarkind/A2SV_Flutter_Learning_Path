import 'package:ecommerce/features/presentation/pages/home.dart';
import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    title: '',
                                  )));
                    },
                    icon: Icon(Icons.arrow_back)),
                Text("Add Product")
              ],
            ),
            Container(
              color: Colors.grey,
              child: Column(
                children: [
                  Icon(Icons.image),
                  Text("Upload Image"),
                ],
              ),
            ),
            Text("Name"),
            Container(),
            Text("Catagory"),
            Container(),
            Text("Price"),
            Container(),
            Text("Description"),
            Container(),
            Column(
              children: [
                ElevatedButton(onPressed: (){}, child: Text("ADD")),
                ElevatedButton(onPressed: (){}, child: Text("DELETE"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
