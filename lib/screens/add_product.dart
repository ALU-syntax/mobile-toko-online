import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class AddProduct extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  AddProduct({super.key});

  Future saveProduct() async{
    final response = await http.post(Uri.parse('http://192.168.1.4:8000/api/products'), body: {
      "name": _nameController.text.toString(),
      "description": _descController.text.toString(),
      // "price": int.parse(_priceController.text),
      "price": _priceController.text.toString(),
      "image_url": _imageUrlController.text.toString()
    });

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Product'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Name";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Description";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Price";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image Url'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Image Url";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    print("Masok");
                    saveProduct().then((value) {
                      Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context) => const HomePage()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Berhasil Dibuat')));
                    });
                  }else{
                    print("gagal");
                  }
                },
                child: const Text('save'))
          ],
        ))
    );
  }
}