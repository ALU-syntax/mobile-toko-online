import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/screens/add_product.dart';
import 'package:toko_online/screens/edit_product.dart';
import 'package:toko_online/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://192.168.1.4:8000/api/products';

  Future getProducts() async{
    var response = await http.get(Uri.parse(url));
    // print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async{
    String url = 'http://192.168.1.4:8000/api/products/$productId';
    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getProducts();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()));
        }),
      appBar: AppBar(
        title: const Text("Neidra Store"),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index){
                  // return Text(snapshot.data['data'][index]['name']);
                  return SizedBox(
                    height: 180,
                    child: Card(
                      elevation: 5,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context)=> ProductDetail(product: snapshot.data['data'][index])));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                              height: 120,
                              width: 120,
                              child: Image.network(snapshot.data['data'][index]['image_url'])),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(snapshot.data['data'][index]['name'], 
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(snapshot.data['data'][index]['description'])),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product: snapshot.data['data'][index],)));
                                            },
                                            child: const Icon(Icons.edit)),
                                          GestureDetector(
                                            onTap: (){
                                              deleteProduct(snapshot.data['data'][index]['id'].toString()).then((value) {
                                                setState(() {});
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Berhasil Dihapus')));
                                              });
                                            },
                                            child: const Icon(Icons.delete)
                                          ),  
                                        ],
                                      ),
                                      Text(snapshot.data['data'][index]['price']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
            }else{
              return const Text('Data Error');
            }
          },
        ),
    );
  }
}