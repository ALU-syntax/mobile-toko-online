import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  final String url = 'http://192.168.1.4:8000/api/products';

  Future getProducts() async{
    var response = await http.get(Uri.parse(url));
    // print(json.decode(response.body));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getProducts();
    return Scaffold(
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
                  return Container(
                    height: 180,
                    child: Card(
                      elevation: 5,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                            height: 120,
                            width: 120,
                            child: Image.network(snapshot.data['data'][index]['image_url'])),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(snapshot.data['data'][index]['name'], 
                                    style: TextStyle(
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
                                      Icon(Icons.edit),
                                      Text(snapshot.data['data'][index]['price']),
                                    ],
                                  )
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
              return Text('Data Error');
            }
          },
        ),
    );
  }
}