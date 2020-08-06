import 'dart:io';

import 'package:flutter/material.dart';
import 'contatos_help.dart';
import 'package:image_picker/image_picker.dart';
class ContatosPage extends StatefulWidget {
  //Adicionando um construtor da classe contatos
  final Contatos contatos;
  //Todo consturto com contatos entre chaves ele não é obrigatorio a ser instanciado
  ContatosPage({this.contatos});
  @override
  _ContatosPageState createState() => _ContatosPageState();
}

class _ContatosPageState extends State<ContatosPage> {
  final _nameControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _phoneControler = TextEditingController();

  final _nameFocus = FocusNode();
  bool _usereditar = false;
  Contatos _editcontatos;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contatos == null)
    {
        _editcontatos = Contatos();//Criando um  novo contato
    }
    else
      {
        _editcontatos = Contatos.fromMap(widget.contatos.toMap());//Passando o contato para map
        //e criando o contato através do map

        _nameControler.text = _editcontatos.name;
        _emailControler.text = _editcontatos.email;
        _phoneControler.text = _editcontatos.phone;
      }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _alertadesair,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          //Se eu nao tiver um contato novo aparecer Novo contato
          title: Text(_editcontatos.name ?? "Novo contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: ()
            {
              //Se o usuario escreveu alguma coisa no nome ele volta para pagina inicial
              //TODO NAVIGATOR É UMA PILHA
              //PRIMEIRO HOME push PARA EDITAR
              //SEGUNDO EDITAR push PARA TERCEIRA PAGINA
              //TERCEIRA PAGINA push...
              //POP
              //Terceura Pagina desempilha Vai para segunda pagina
              //desempilha editar vai para home
              //Logo é push para pagina a frente pop voltar para trás
              if(_editcontatos.name != null && _editcontatos.name.isNotEmpty)
              {
                print("asdsadsadsasda ENTOU AQUI MSADSADSASADASDSADADSASDDASDASASDASDASDDSASADDSA");
                Navigator.pop(context,_editcontatos);
              }//Caso o usuario não preenchar o nome ele dar um foco para o usuario preencher
              else
              {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.deepPurple
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //Caso o contato tenha uma imagem carrega a imagem
                    image: DecorationImage(image: _editcontatos.img != null ?
                    FileImage(File(_editcontatos.img))
                    //Caso o contato não coloque imagem carregar outro icon
                        :
                    AssetImage("images/person.png"),

                    ),
                  ),
                ),
                onTap: () async
                {
                  _OpcoesDeMudar();
                },
              ),
              TextField(
                controller:  _nameControler,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _usereditar = true;
                  setState(() {
                    _editcontatos.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailControler,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _usereditar = true;
                  _editcontatos.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneControler,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  _usereditar = true;
                  _editcontatos.phone = text;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _alertadesair()
  {
    if(_usereditar) 
    {
      showDialog(context: context, builder: (context)
      {
        return AlertDialog(
          title: Text("Descartar alterações"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: ()
              {
                //Saindo da tela do dialogo
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sair"),
              onPressed: ()
              {
                //saindo da tela do dialogo e da pagina de edição indo para a pagina home
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],

        );
      });
      return Future.value(false);//Se o usuario editou alguma coisa pergunta se ele quer sair da pagina
    }
    else
    {
      return Future.value(true);//Se o não usuario editou ele simplismente sair da pagina e dar um pop
    }
  }

  void _OpcoesDeMudar()
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
                    child: Text("Galeria", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                    ),
                    onPressed: () async
                    {
                      File ImagemPerfil;
                      File Imagem;
                      ImagemPerfil = await ImagePicker.pickImage(source: ImageSource.gallery).then((file)
                      {
                        if(file == null) return;
                        setState(() {
                          Navigator.pop(context);
                          Imagem = ImagemPerfil;
                          _editcontatos.img = file.path;
                          _usereditar = true;
                        });
                      });

                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text("Camera", style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                    ),
                    onPressed: () async
                    {
                      File ImagemPerfil;
                      File Imagem;
                      ImagemPerfil = await ImagePicker.pickImage(source: ImageSource.camera).then((file)
                      {
                        if(file == null) return;
                        setState(() {
                          Navigator.pop(context);
                          Imagem = ImagemPerfil;
                          _editcontatos.img = file.path;
                          _usereditar = true;
                        });
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
}
