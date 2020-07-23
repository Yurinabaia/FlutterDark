import 'dart:convert';

import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
//Serve
void main()
{
  runApp(MaterialApp(
      home: Home()

  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final adicionaTarefasControllers = TextEditingController();
  List _tarefas = [];
  Map<String, dynamic> _RemoverItem;
  int _posRemovido;
  @override
  void initState() {
    super.initState();
    _Lerdados().then((dados)
    {
      setState(() {
        _tarefas = json.decode(dados);
      });
    });
    //O ler dados vai retorna uma future e depois vai executar o the que
    //é uma função anonima
  }

  void _adicionarTarefas()
  {
    setState(() {
      Map<String, dynamic> NovoMapa = Map();
      NovoMapa["title"] = adicionaTarefasControllers.text;
      adicionaTarefasControllers.text = "";
      NovoMapa["ok"] = false;
      _tarefas.add(NovoMapa);
      _saveData();
      //Pegar todo minha lista e salva em json

    });
  }

  Future<Null> _refrash() async
  {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      //Fazendo um delay para atualizar a lista
      _tarefas.sort((a,b)
      {
        if(a["ok"] && !b["ok"])
          return 1;
        else if(!a["ok"] && b["ok"])
          return -1;
        else return 0;
      });
      //ISSO AQUI ORDENA MINHA LISTA
      _saveData();
    });
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(//Serve como cabeçalho do nosso app
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.8, 7.8, 3.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: adicionaTarefasControllers,
                    decoration: InputDecoration(
                        labelText: "Nova decoração",
                        labelStyle: TextStyle(color: Colors.blue)
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Text("Add"),
                  textColor: Colors.white,
                  onPressed: _adicionarTarefas,//o onPressed é a função do Button,
                )
              ],
            )
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refrash,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _tarefas.length,
                  itemBuilder: chamadorCheckBox),

            ),
          ),
        ],
      ),
    );
  }

  //Aqui vai fazer a lista de cada item
  Widget chamadorCheckBox (BuildContext context,int index)
  {
    //Aqui vou ter a tabela da minha lista
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white,),
            //O filho de cima serve para colocar a lixeira quando arrasta
            //o objeto
          ),//Serve para alinhar o filho
        ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_tarefas[index]["title"]),
        value: _tarefas[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_tarefas[index]["ok"] ?
          Icons.check : Icons.error
          ),
        ),
        onChanged: (c){
          setState(() {
            _tarefas[index]["ok"] = c;
            _saveData();
            //Pegar todo minha lista e salva em json

          });
        },
      ),
      //O comando acima determina o usuario arasta da esquerda para direita
      onDismissed: (direction)
      {
        setState(() {
          _RemoverItem = Map.from(_tarefas[index]);
          _posRemovido = index;
          _tarefas.removeAt(index);
          _saveData();
          final snack = SnackBar(
              content: Text("Tarefa \"${_RemoverItem["title"]}\" removida!!!"),
            action: SnackBarAction(label: "Desfazer", onPressed: () {
              setState(() {
                _tarefas.insert(_posRemovido, _RemoverItem);//Recuperando item removido
                _saveData();//Salvando os dados de Json
              });
            },),
            duration: Duration(seconds: 2),
            //Tempo de duração do para desfazer a remoção do item
          );//Ele serve para aparece a mensagem
          //de confirmação de remoção de item

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
          //O comando acima faz aparece os dados de desfazer no app
        });
      },
    );//Esse é o Widget que arrasta para direita
  }
  //Future normalmente utilizar o async
  Future<File> _getFile() async
  {
    final directory = await getApplicationDocumentsDirectory();
    //getApplicationDocumentsDirectory SERVER PARA ARMAZENAR DADOS NO ANDROID
    //E IOS

    return File("${directory.path}/data.json");//Aqui estou armazenando meus dados
    //na pasta do android e Ios

  }
//Future normalmente utilizar o async
  Future<File> _saveData() async
  {
    String data = json.encode(_tarefas);
    //Aqui está transformando minha lista em Json
    final file = await _getFile();
    //Aqui pega o arquivo que vai salva, esperando o arquivo com await
    return file.writeAsString(data);
    //Aqui vamos escreve o arquivo
  }
  Future<String> _Lerdados() async
  {
    try
    {
      final file = await _getFile();
      return file.readAsString();//Lendo os arquivo em String
    }
    catch (e)
    {
        return null;
    }
  }
}
