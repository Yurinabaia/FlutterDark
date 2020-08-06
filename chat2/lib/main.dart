import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'chatS.dart';

void main() async {
  runApp(MyApp());
  //Todo Para executar e testa o firebase é preciso apagar qualquer instance do farebase, executar o app
  //Todo e depois coloque novamente as intancias do firebase
  //Todo no arquivo no diretorio app/buildgradle enconte
  // Todo defaultConfig {
  //Todo  ...
  //Todo   multiDexEnabled true
  //Todo}
  //Todo E depois execute no terminal flutter pub upgrade e/ou flutter clean


  //Para iniciar o app é preciso instance e depois escolher qual o nome da collection
  //depois qual a document que seria meu id unico, depois o setData vai escrever o campo no banco de dados

  //Exemplo abaixo está escrevendo no banco de dados, criando um collection mensagem
  //e document com id unico, depois escrevendo com setData.
  /*
  Firestore.instance.collection("mensagem").document().collection("asd").document().setData({
    "Texto" : "Ola",
    "from" : "Nabaia",
    "read": false,
  });*/

  //A estrutura do Firestore é colection document, colection document, colection document....
  //assim por diante, ele faz a referencia dos dados salvando no banco de dados


  //Exemplo abaixo está lendo os dados no banco de dado de todos os documents
  // Primeiro criou o QuerySnapshot snapshot para pegar o momento do BD
  // Segundo o await pois é um dados Future
  // Terceiro eu instancio o Bd depois acho a collection no bd e depois acho os dados
  // Quarto chamo o getDocuments para busca os dados de todos os document da minha collection

  /*
  QuerySnapshot snapshot = await Firestore.instance.collection("mensagem").getDocuments();
  //Agora posso mecher em todos meu document de uma vez
  snapshot.documents.forEach((element) {
    print(element.data);//Estou printando todos elemento da minha collection
    print(element.documentID);//Estou printando todos os id do meu document
    element.reference.updateData({'read': true});//Estou atualizando todos meu documentos para read(lido)
  });
  */

  //Exemplo abaixo está lendo os dados no banco de um id especifico
/*
  DocumentSnapshot docsnapshot = await Firestore.instance.collection("mensagem").document("Owc8tMlz7S6snzd8mKAl").get();
  print(docsnapshot.data);//Estou printando todos elemento da minha collection
*/

  //Exemplo abaixo está averiguando se está sendo atualizado algum dado meu em tempo de execução
  //de todos os documents
  /*
  Firestore.instance.collection("mensagem").snapshots().listen((dado) {
    dado.documents.forEach((d) { //Averiguando todos os dados se ele foi alterado
      print(d.data);//verificando todos os dados
    });
    //print(dado.documents[0].data);apenas um dado especifico para ser averiguar se ele foi alterado
  });
  */

  //Exemplo abaixo está averiguando se está sendo atualizado algum dado em tode de execuçãp
  //de apenas um documets
  /*
  Firestore.instance.collection("mensagem").document("Owc8tMlz7S6snzd8mKAl").snapshots().listen((dado) {
    print(dado.data);
  });
   */
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        iconTheme: IconThemeData(
          color: Colors.deepPurple
        ),
      ),
      home: chatScat(),
    );
  }
}