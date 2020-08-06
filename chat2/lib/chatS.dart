import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'compose.dart';
import 'ChatM.dart';
class chatScat extends StatefulWidget {
  @override
  _chatScatState createState() => _chatScatState();
}

class _chatScatState extends State<chatScat> {

  FirebaseUser _current;
  bool _carregandoImg = false;
  //Iniciando com login do google
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _ScafooldKey = GlobalKey<ScaffoldState>();//Mensagem de erro
  @override
  void initState() {
    super.initState();
    //Sempre que autorização mudar ele passar aqui
    FirebaseAuth.instance.onAuthStateChanged.listen((user)
    {
      setState(() {
        _current = user;
      });
    });
  }

  Future<FirebaseUser> _Login () async
  {
    if(_current != null ) return _current;
    try
    {
      //Aqui estou pegando os dados da google
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      //Pegando os dados de auteticação com token
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      //buscando a conta do google e pegando o Token do google
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //Eviando o login da google para o FileBase
      //Ele funcionar pra qualquer um, sendo google facebook etc...
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = authResult.user;

      return user;//Se deu tudo certo eu retorno o usuario
    }
    catch (e)
    {
        return null;
    }
  }

  void senderMenseger({String text, File ImagemPerfil} ) async
  {
    final FirebaseUser user = await _Login();
    if(user == null)
    {
      _ScafooldKey.currentState.showSnackBar(
       SnackBar(
         content: Text("Não foi possivel fazer o login. Tente o email ou senha certo"),
         backgroundColor: Colors.deepOrange,
       )
      );
    }
    //Informações do usuario
    Map<String, dynamic> data = {
        "uid": user.uid,
        "senderName": user.displayName,
        "senderPhotoUrl": user.photoUrl,
        "time": Timestamp.now(),

    };
    //Enviado imagem para o FileBase
    if(ImagemPerfil != null)
    {
      //Aqui estou upando a imagem, o .child pode ser usado para criar pasta
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
        user.uid + DateTime.now().millisecondsSinceEpoch.toString()//Aqui é o nome da imagem
      ).putFile(ImagemPerfil);

      setState(() {
        _carregandoImg = true;
      });
      StorageTaskSnapshot taskSnapshot =  await task.onComplete;//Espera ser completado
      String urlFoto = await taskSnapshot.ref.getDownloadURL();//URL DA IMAGEM
      data['imgUrl'] = urlFoto;

      setState(() {
        _carregandoImg = false;
      });



    }
    //Se text não for nula enviar o texto para o banco pelo Map data
    if(text != null  )
    {
      data['text'] = text;
    }
       Firestore.instance.collection("mensagem").document().setData(data);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ScafooldKey,
      appBar: AppBar(
        title: Text(_current != null ?  "logado com ${_current.displayName}" : "Chat do Nabaia"),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _current != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            //Fazer lagaout
            onPressed: ()
            {
              FirebaseAuth.instance.signOut();
              googleSignIn.signOut();
              _ScafooldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Saiu com sucesso!! \n Obrigado por usar meu app by NABAIA"),
                  )
              );
            },
          ) : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            //StreamBuilder vai reconstruir o app sempre que tiver algo novo
            child: StreamBuilder<QuerySnapshot>(
              //Sempre que tiver alguma modificação ele acionar o stream
              stream: Firestore.instance.collection("mensagem").orderBy('time').snapshots(),
              builder: (context, snpshot) {
                //Caso tenha que esperar ele vai aparece uma animação
                switch(snpshot.connectionState)
                {
                  case ConnectionState.none :
                  case ConnectionState.waiting :
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default :
                    List <DocumentSnapshot> documents =  snpshot.data.documents.reversed.toList();
                    return ListView.builder(

                        itemCount: documents.length,//a quantidade de documentos
                        reverse: true,//As mensagem vai aparecer de baixo para cima
                        itemBuilder: (context, index)
                        {
                          return ChatMessage(documents[index].data,
                          documents[index].data['uid'] == _current?.uid);
                        }
                        );

                }
              },
            ),
          ),
          _carregandoImg ? LinearProgressIndicator() : Container(),
          Textcompose(senderMenseger),
        ],
      )
    );
  }
}
