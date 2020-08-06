import "package:flutter/material.dart";
import 'package:buscado_gif/ui/home_page.dart';
//Buscando arquivo em outra pasta
void main() 
{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.white),
  ));
}

