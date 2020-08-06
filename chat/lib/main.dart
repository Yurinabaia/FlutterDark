import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
void main() async {
  runApp(MyApp());
  Firestore.instance.collection("col").document("doc").setData({"Texto": "Yuri"});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
    );
  }
}