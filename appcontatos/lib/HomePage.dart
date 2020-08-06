import 'dart:io';

import "package:flutter/material.dart";
import 'ContatosPage.dart';
import "contatos_help.dart";
import "package:url_launcher/url_launcher.dart"; //Para poder chamar o teclado de ligacao

enum OrdenarContatos {orderaz, orderzA}
class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  ContatoHelp help1 = ContatoHelp();
  //Se eu chamar o help2
  //ContatoHelp help2 = ContatoHelp();
  //Ele ira receber os mesmo valores do help1, pois criamos uma classe de apenas um objeto
  //a classe ContatoHelp é apenas um objeto


  List<Contatos> ListContatos = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _atualizandoContato();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrdenarContatos>(
            itemBuilder: (context) => <PopupMenuEntry<OrdenarContatos>>
              [
                const PopupMenuItem(
                  child: Text("Ordenar de A-Z "),
                    value: OrdenarContatos.orderaz,
                ),
                const PopupMenuItem(
                child: Text("Ordenar de Z-A "),
                value: OrdenarContatos.orderzA,
              ),
            ],
              onSelected: _ordenaLista,
          )

        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _MudarPagina();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: ListContatos.length,
          itemBuilder: (context, index)
          {
            return _contatosLista(context, index);
          }),
    );
  }
  Widget _contatosLista(BuildContext context, int index)
  {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //Caso o contato tenha uma imagem carrega a imagem
                  image: DecorationImage(image: ListContatos[index].img != null ?
                  FileImage(File(ListContatos[index].img))
                  //Caso o contato não coloque imagem carregar outro icon
                      :
                  AssetImage("images/person.png"),

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Caso o usuario coloque o nome vazio aparecera "" isso
                    Text(ListContatos[index].name ?? "", style: TextStyle(fontSize: 22.0,
                        fontWeight: FontWeight.bold)),
                    Text(ListContatos[index].email ?? "", style: TextStyle(fontSize: 18.0)),
                    Text(ListContatos[index].phone ?? "", style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: ()
      {
        _OpcoesDeMudar(context, index);
      },
    );
  }

  void _OpcoesDeMudar(BuildContext context, int index)
  {
    showModalBottomSheet(context: context, builder: (context)
    {
      return BottomSheet(
        onClosing: (){},
        builder: (context)
        {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("Ligar", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                    ),
                    onPressed: ()
                    {
                        launch("tel:${ListContatos[index].phone}");
                        Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("Editar", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                    ),
                    onPressed: ()
                    {
                      Navigator.pop(context);
                      _MudarPagina(contatos: ListContatos[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("Excluir", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                    ),
                    onPressed: ()
                    {
                      help1.deletContact(ListContatos[index].id);
                      setState(() {
                        ListContatos.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
  //Aqui estou mudando de pagina
  void _MudarPagina({Contatos contatos})async
  {
    final atualizando = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContatosPage(contatos: contatos,))
    );
    if(atualizando != null)
    {
      //Atualizando contato existente
      if(contatos != null)
      {
        await help1.updateContato(atualizando);
      }
      //Criando novo contato
      else
      {
        await help1.saveContact(atualizando);
      }
      _atualizandoContato();

    }
  }

  void _atualizandoContato()
  {
    help1.getObterTodosContatos().then((list) =>
        setState(() {
          ListContatos = list;
        }));
  }
  void _ordenaLista(OrdenarContatos result)
  {
      switch(result)
      {
        case OrdenarContatos.orderaz:
          ListContatos.sort((a,b)
          {
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
          break;
        case OrdenarContatos.orderzA:
          ListContatos.sort((a,b)
          {
           return b.name.toLowerCase().compareTo(a.name.toLowerCase());
          });
          break;
      }
      setState(() {

      });
  }
}
