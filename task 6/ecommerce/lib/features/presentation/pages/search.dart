import 'package:ecommerce/features/presentation/pages/home.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  RangeValues _rangeValues = const RangeValues(10, 80);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back button and title
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home(title: "")),
                      );
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Search Product",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Quick filter: Leather
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text("Leather"),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_right_alt_outlined),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                ],
              ),

              const SizedBox(height: 20),

              /// Name input
              const Text("Name"),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter product name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Category input
              const Text("Category"),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  hintText: "Enter category",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// Price range
              const Text("Price Range"),
              RangeSlider(
                values: _rangeValues,
                min: 0,
                max: 100,
                divisions: 10,
                labels: RangeLabels(
                  _rangeValues.start.round().toString(),
                  _rangeValues.end.round().toString(),
                ),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey.shade300,
                onChanged: (RangeValues newValues) {
                  setState(() {
                    _rangeValues = newValues;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Apply button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Apply logic here
                    print("Name: ${_nameController.text}");
                    print("Category: ${_categoryController.text}");
                    print("Price Range: ${_rangeValues.start} - ${_rangeValues.end}");
                  },
                  child: const Text("APPLY"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
