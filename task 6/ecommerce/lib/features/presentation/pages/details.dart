import 'package:ecommerce/features/presentation/pages/home.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FloatingActionButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(title: "")));
          }, child: Icon(Icons.arrow_back_ios_new_outlined),),
          Container(
            child: Image.network("src"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Men's Shoe"),
              Row(children: [
                Icon(Icons.star, color: Colors.yellowAccent,),
                Text("4.00")
              ],)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Derby Leather", style: TextStyle(fontWeight: FontWeight.bold,)),
              Text("120 Birr")
            ],
          ),
          Column(
            children: [
              Text("Size"),
              SizedBox(
                height: 50, // give it height so it can render
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8, // 38 to 45 inclusive
                  itemBuilder: (context, index) {
                    final size = 38 + index;
                    return Container(
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(size.toString()),
                                    );
                                  },
                                ),
                              ),
              Container(child: Text("A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe."),),
              Row(children: [OutlinedButton(onPressed: (){}, child: Text("DELETE")),
              ElevatedButton(onPressed: (){}, child: Text("UPDATE"))],)
            ],
          ),
          


    
        ],
      ),


    );
  }
}