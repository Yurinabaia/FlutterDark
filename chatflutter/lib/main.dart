import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
void main() {
  runApp(MyApp());
  Firestore.instance.collection("col").document("doc").setData({"Texto": "Yuri"});

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(),
    );
  }
}