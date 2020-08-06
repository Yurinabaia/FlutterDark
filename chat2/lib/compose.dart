import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
class Textcompose extends StatefulWidget {
  Textcompose(this.sendeMenseger);
  final Function({String text , File ImagemPerfil} ) sendeMenseger;
  @override
  _TextcomposeState createState() => _TextcomposeState();
}

class _TextcomposeState extends State<Textcompose> {
  final TextEditingController _controller = TextEditingController();
  bool _habilitarenivar = false;
  void apagar()
  {
    _controller.clear();
    setState(() {
      _habilitarenivar = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal : 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_camera),
            onPressed:  () async
            {
              final File ImagemPerfil = await ImagePicker.pickImage(source: ImageSource.camera);
              if(ImagemPerfil == null) return;
              widget.sendeMenseger(ImagemPerfil: ImagemPerfil);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed:  () async
            {
             final File ImagemPerfil = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(ImagemPerfil == null) return;
              widget.sendeMenseger(ImagemPerfil: ImagemPerfil);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(hintText: "Enivar uma mensagem"),
              onChanged: (text) {
                  setState(() {
                      _habilitarenivar = text.isNotEmpty;//Se o texto não estiver vazio vai dar true
                  });
              },
              onSubmitted: (text)
              {
                widget.sendeMenseger(text : text);
                apagar();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _habilitarenivar ? ()
            {
              widget.sendeMenseger(text : _controller.text);
              apagar();
            } : null,
          ),
        ],
      ),
    );
  }
}
