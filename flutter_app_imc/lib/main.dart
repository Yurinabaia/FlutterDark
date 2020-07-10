import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    //No home podemos passar o stateless ou statefull
    //O statefull PODEMOS MODIFICAR E TER ALTERAÇÃO NO TEMPO DE EXECUÇÃO DO PROGRAMA
    //O stateless NÃO PODEMOS MODIFICAR EM TEMPO DE EXECUÇÃO

    home: Home(),
  )); //Serve para iniciar meu app
}

//Para acrescentar o state full digite stfull e der enter
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weigthPesoController = new TextEditingController();

  //weigthController serve para eu controla o campo de texto
  TextEditingController heigthAlturaController = new TextEditingController();

  //heigthController serve para eu controlar o campo de texto


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //_formKey serve para tratar os erros do meu app
  String _Infor = "Info";

  void _ControlarTexto() {
    weigthPesoController.text = ""; //Apagando meu campos de texto PESO
    heigthAlturaController.text = ""; //Apagando meu campos de texto ALTURA
    setState(() {
      _Infor = "Informe os dados acima";
      _formKey = GlobalKey<FormState>();    // ADICIONE ESTA LINHA!

    });
    //O setState() funcionar para atualizar meu campo na hora de execução do meu programa
  }

  void _ControlarMMC() {
    double PESO = double.parse(weigthPesoController.text);
    double ALTURA = double.parse(heigthAlturaController.text);
    weigthPesoController.text = ""; //Apagando meu campos de texto PESO
    heigthAlturaController.text = ""; //Apagando meu campos de texto ALTURA
    ALTURA = ALTURA / 100;
    ALTURA = ALTURA * ALTURA;
    double resposta = (PESO / ALTURA);
    resposta = double.parse(resposta.toStringAsFixed(2));
    setState(() {
      if (resposta < 18.5)
        _Infor = "Abaixo do peso valor: $resposta";
      else if (resposta >= 18.5 && resposta < 24.9)
        _Infor = "Peso normal valor: $resposta";
      else if (resposta >= 24.9 && resposta < 29.9)
        _Infor = "Sobrepeso valor: $resposta";
      else if (resposta >= 29.9 && resposta < 34.9)
        _Infor = "Obesidade grau 1 valor: $resposta";
      else if (resposta >= 34.9 && resposta < 39.9)
        _Infor = "Obesidade grau 2 valor: $resposta";
      else
        _Infor = "Obesidade grau 3 valor: $resposta";
    });
    //O setState() funcionar para atualizar meu campo na hora de execução do meu programa
  }

  @override
  Widget build(BuildContext context) {
    //O Scaffold é minha template de fundo
    //o appBar seria o cabeçalho do meu app
    //Title é o que vai aparecer no meu app
    //centerTitle centralizando o titulo
    //TextStyle é para editar a cor e o tamnho do texto ou formato;
    //onPressed é sempre o botão
    //Sempre que for trabalho em vertical usar o Column(),
    //TextField() ira aparece o teclado do celular
    //TextFormField ira aparece o teclado do celular tendo diferença o parametro validator
    //RaisedButton() é um botão com bordas, //TODO BOTÃO TEM APENAS UM FILHO
    //Container, //TODO COMO SE FOSSE DIV DE HTML
    //SingleChildScrollView, //TODO BARRA DE ROLAGEM
    //Meu Form serve para tra os erros da meu app
    //Dentro do meu form eu passo minha key que foi a variavel global criada
    //padding: EdgeInsets.fromLTRB serve para colocar um espaçamento nas laterais
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true, //Centralizando o titulo
        backgroundColor: Colors.cyan, //Cor do meu cabeçalho
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh), //Icone do meu cabeçalho
            onPressed: () {
              _ControlarTexto();
            }, //onPressed é o meu botão
          )
        ],
      ),
      //Saindo da nossa barra
      //Entrando no corpo do meu app body
      backgroundColor: Colors.white, //Definir a cor do corpo do app
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        //paddig é o espaçamento nas laterais
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              //Vai alarga tudo que se encontra na minha coluna
              children: <Widget>[
                Icon(Icons.account_circle, size: 120.0, color: Colors.cyan),
                //Icon seria meu icone de contato
                //size é o tamnho do icone
                //color é a cor do meu icone

                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: weigthPesoController,
                  //Controlar o campo de texto

                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insirar seu peso";
                    }
                  },
                ),
                //O TextField() faz aparece o teclado
                //keyboardType: limitar apenas digitar números ou letras
                //InputDecoration: Serve para declarar um input
                //labelText: É A INFORMAÇÃO DA LABEL
                //textAlign: SIGNIFICAR O TEXTO NO CENTRO, LABEL NO CENTRO NESTE CASO

                //decoration serve apenas para fazer a decoração dos campos de texto
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.green)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: heigthAlturaController,
                  //Controlar o campo de texto
                  // ignore: missing_return
                  validator: (value) {
                    if(value.isEmpty)
                    {
                      return "Insirar sua altura em cm";
                    }
                  },
                ),
                //O TextField() faz aparece o teclado
                //keyboardType: limitar apenas digitar números ou letras
                //InputDecoration: Serve para declarar um input
                //labelText: É A INFORMAÇÃO DA LABEL
                //textAlign: SIGNIFICAR O TEXTO NO CENTRO, LABEL NO CENTRO NESTE CASO

                //decoration serve apenas para fazer a decoração dos campos de texto

                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),

                  height: 50.0,
                  width: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate())
                      {
                        _ControlarMMC();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    color: Colors.green,

                    // RaisedButton() é um botão com bordas
                  ),

                  //Container serviu para colocar a alturar do campo do botão
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      "$_Infor",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green, fontSize: 25.0),
                    ))
              ]),
        ),
      ),
    );
  }
}
