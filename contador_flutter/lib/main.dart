import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  //DENTRO DO runApp () passei como parametro um Widget chamado MaterialApp

  //é preciso baixar a biblioteca package:flutter/material.dart

  //Existe dois tipos de Widget o Stateless e o Stateful
  //O Stateless NÃO pode ser alterado, modificado seus valores internos
  //O Stateful ALTERAR de acordo com uma ação do app
  //no caso deste app a ação é o botão +1 e -1

  runApp(new MaterialApp(
      //Definimos os valores no flutter atraves de dois pontos :
      //Tudo que está dentro do runApp NÃO termina com ; APENAS VIRGULAS
      title: "Contador de pessoas",
      //Titulo do app

      home: Home())); // O runApp Serve para executar nosso programa
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pessoas = 0;
  String _infoTeste = "Pode Entrar";

  //O metodo _PessoasAD acrescento ou decrementa o valor da variavel
  void _PessoasAD(int valor)
  {
    setState(() {
      _pessoas = valor;
      if(_pessoas == -1)
        _pessoas = 0;
    });
    //O setState() atualizar minha pagina em tempo real


    setState(() {
      if(_pessoas > 10)
      {
        _infoTeste = "Não pode entrar";
        _pessoas = 10;
      }
      else
        _infoTeste = "Pode Entrar";

    });
    //O setState() atualizar minha pagina em tempo real

  }

  @override

  Widget build(BuildContext context) {
    //Primeiro definimos a imagem do nosso programa
    //Para isso usamos o Stack que faz colocar a imagem atras

    //Dentro do Stack criamos um filho childen
    //E dentro do filho colocamos uma image.asset

    //Aqui em baixo tem uma coluna
    //Em seguida o filho da coluna
    //Em seguida tem dois text do filho da coluna
    //Em seguida o atributo em String chamado pessoa
    //com o style deste atributo

    //Em seguida tenho uma linha chamado Row para receber meus botões
    //Em seguida tenho um filho para minha linha Row
    //Em seguida tenho o pading para os botões de acrescentar e diminuir
    //Em seguida o botão botão chamado FlatButton e todos botões tem apenas um filho
    //Em seguida temos um text com o style
    //Em seguida temos o onPressed serve para executar o botão
    //isso (){} é uma função anonima



    return Stack(
      children: <Widget>[
        Image.asset(
          "img/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1080.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //Significa que essa coluna
          //vai está no centro verticalmente.
          children: <Widget>[
            Text(
              "Pessoas: $_pessoas",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  //Aqui estou colocando um padding
                  //em todos as laterais da minha caixa

                  child: FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed:() {_pessoas++; _PessoasAD(_pessoas); debugPrint("$_pessoas");}, //Serve para executar o botão em um função, no caso função anonima () {}
                 //Dentro das chaves no onPressed você tem que fechar com ;
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  //Aqui estou colocando um padding
                  //em todos as laterais da minha caixa

                  child: FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {_pessoas--;_PessoasAD(_pessoas--);}, //Serve para executar o botão em um função, no caso função anonima () {}
                    //Dentro das chaves no onPressed você tem que fechar com ;
                  ),
                ),
              ],
            ),
            Text(
              _infoTeste,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30),
            )
          ],
        )
      ],
    );
  }
}
