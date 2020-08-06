import 'package:flutter/material.dart';
import 'package:share/share.dart';
class Gifs extends StatelessWidget {
  final Map _gifData;
  Gifs(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: ()
            {
              Share.share(_gifData["images"]["fixed_height"]["url"]);
              //Poder compartilhar o gif

            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

