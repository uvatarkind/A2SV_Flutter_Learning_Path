import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_pages/feature/product/domain/entities/product.dart';
import 'package:ui_pages/feature/product/presentation/bloc/product_bloc.dart';
import 'package:ui_pages/feature/product/presentation/bloc/product_event.dart';
class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_sharp, color: Color(0xFF3F51F3)),

          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),

        title: Container(
          margin: EdgeInsets.only(left: 87),
          child: Text("Add Product ", style: TextStyle(fontSize: 23)),
        ),
      ),
      body: Padding(
  padding: EdgeInsets.all(20),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _pickImage,
          child: Column(
            children: [
              SizedBox(height: 40),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 120, fit: BoxFit.cover)
                  : Icon(Icons.image_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                _imageFile != null ? "Change image" : "Upload image",
                style: TextStyle(fontSize: 16, fontFamily: "Mono-sans"),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),

        Text("name"),
        SizedBox(height: 10),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(20, 117, 115, 115),
            filled: true,
            border: InputBorder.none,
          ),
        ),

        SizedBox(height: 15),
        Text("price"),
        SizedBox(height: 5),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.attach_money),
            fillColor: const Color.fromARGB(20, 117, 115, 115),
            filled: true,
            border: InputBorder.none,
          ),
        ),

        SizedBox(height: 15),
        Text("description"),
        SizedBox(height: 5),
        TextField(
          controller: descriptionController,
          maxLines: 6,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(20, 117, 115, 115),
            filled: true,
            border: InputBorder.none,
          ),
        ),

        SizedBox(height: 20),

        FilledButton(
          onPressed: () {
            // collect form data
            final newProduct = Product(
              id: '',
              name: nameController.text,
              price: double.tryParse(priceController.text) ?? 0.0,
              description: descriptionController.text,
              imageUrl: _imageFile?.path ?? '', // ✅ use selected image path
            );

            context.read<ProductBloc>().add(CreateProductEvent(newProduct));
            Navigator.pop(context, true); // notify MyHomePage to reload
          },
          style: FilledButton.styleFrom(
            padding: EdgeInsets.fromLTRB(49, 17, 49, 17),
            backgroundColor: Color(0xFF3F51F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "ADD",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),

        SizedBox(height: 10),

        OutlinedButton(
          onPressed: () {
            // optional: implement delete logic
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(49, 17, 49, 17),
            foregroundColor: Colors.red,
            side: BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "DELETE",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      ],
    ),
  ),
),

    );
  }
}