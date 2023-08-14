import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class EditProduct extends StatelessWidget {
  final Map product;

  EditProduct({required this.product});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  

  Future updateProduct() async{
    final response = await http.put(Uri.parse('http://192.168.1.4:8000/api/products/${product['id'].toString()}' ), body: {
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
        title: const Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController..text = product['name'],
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Name";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descController..text = product['description'],
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Description";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController..text = product['price'],
              decoration: const InputDecoration(labelText: 'Price'),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Insert Product Price";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController..text = product['image_url'],
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
                    updateProduct().then((value) {
                      Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context) => const HomePage()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Berhasil Diubah')));
                    });
                  }else{
                    print("gagal");
                  }
                },
                child: const Text('Update'))
          ],
        ))
    );
  }
}