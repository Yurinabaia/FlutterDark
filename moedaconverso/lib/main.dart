import 'dart:convert';
//Bilbioteca com a função de converter o Json em um map

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//Essa biblioteca permitir fazer as requicições

import 'package:async/async.dart';
//Essa biblioteca permitir que fazemos as tarefas assicrona

const request = "https://api.hgbrasil.com/finance?key=5681e48f";
//Acima está minha constante, nela possui o request para busca minha API
void main() async //Colocando async na função, faz com que a função seja
//assicrona e assim funcionara o await
{
  print(await RetornarMapaDaApi());
  //O await significa que estou buscando os dados da Api de forma
  //assicrona
  runApp(MaterialApp(home: Home(),  theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  void _RealBuild(String text)
  {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
      double Real = double.parse(text);
      dolarController.text = (Real/dolar).toStringAsFixed(2);
      euroController.text = (Real/euro).toStringAsFixed(2);
      //o  toStringAsFixed DEIXA APENAS DOIS DIGITOS NO DOUBLE
  }
  void _DolarBuild(String text)
  {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double Dolar = double.parse(text);
    realController.text = (Dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (Dolar * this.dolar/this.euro).toStringAsFixed(2);
    //o  toStringAsFixed DEIXA APENAS DOIS DIGITOS NO DOUBLE

  }
  void _EuroBuild(String text)
  {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double Euro = double.parse(text);
    realController.text = (Euro * this.euro).toStringAsFixed(2);
    dolarController.text = (Euro * this.euro / dolar).toStringAsFixed(2);
    //o  toStringAsFixed DEIXA APENAS DOIS DIGITOS NO DOUBLE

  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
  double dolar;
  double euro;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      //AppBar serve para definimos como vai ser nossa barra
      //Neste caso o cabeçalho
      //a \$ significa que estou pegando o simbolo do cifrão e não a variavel
      body: FutureBuilder<Map>(
          future: RetornarMapaDaApi(),
          builder: (context, snapshot){ //context = Contexto do app e
              //snapshot é a uma fotografia momentanea do servidor
            switch (snapshot.connectionState) { //Serva para avaliar o status
                //Da nossa conexão
              case ConnectionState.none ://Se não tiver nada para ser retornado
              case ConnectionState.waiting ://Se estiver em esperar os dados
                return Center(//Center centraliza outro Wigtget
                  child: Text("Carregando dados...",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError)
                {
                  return Center(//Center centraliza outro Wigtget
                    child: Text("Error ao carregar...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else
                  {
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                          buildTextFiel("Reais", "R\$", realController, _RealBuild),
                          Divider(),
                          buildTextFiel("Dolares", "US\$", dolarController, _DolarBuild),
                          Divider(),
                          buildTextFiel("Euros", "€", euroController, _EuroBuild)
                        ],
                      ),
                    );
                  }
            }
          }),
      //O FutureBuilder significar que meus dados vai está sendo carregado
      //De forma que o aparece uma informação no app para o usuario ver
      //Assim não trava o app até que aquela requicição seja feita
    ); //Scaffold Permitir o cabeçalho do app
  }
}

Widget buildTextFiel(String Moeda, String Cifrao, TextEditingController controlar, Function f)
{
  return TextField(
      controller: controlar,
      decoration: InputDecoration(
          labelText: Moeda,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: Cifrao + ":  "
      ),
      style: TextStyle(
          color: Colors.amber, fontSize: 25.0
      ),
      keyboardType: TextInputType.number,
      onChanged: f,
  );
}


//O Future significa que vou buscar um dado no futuro, logo
//serve para funções de async assicrona
Future<Map> RetornarMapaDaApi() async
//Colocando async na função, faz com que a função seja
//assicrona e assim funcionara o await
{
  http.Response res = await http.get(request);
  //Aqui estou buscando minha API
  return json.decode(res.body);
  //O json.decode faz com que eu converta o Json em maps
  //Depois eu printei apenas o result do currencie em USD(DOLAR);
}
