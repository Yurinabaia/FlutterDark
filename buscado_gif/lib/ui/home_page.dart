import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _serch;
  int _ofSet = 0;
  Future<Map> _getSech() async
  {
      http.Response response;
      if(_serch == null || _serch.isEmpty)
      {
        response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=aE3dhPpigeKgzjrVVyktgILWPJAnLeeZ&limit=20&rating=g");
        //Fazendo uma requicição dos gifs através da API
      }
      else
        {
            response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=aE3dhPpigeKgzjrVVyktgILWPJAnLeeZ&q=$_serch&limit=19&offset=$_ofSet&rating=g&lang=en");
            //Fazendo uma requicição dos gifs através da api entretando com a pesquisa do usuario;
          //O $_serch siginifica a pesquisa do usuario
          //o $_ofSet significa a quantidade de resultados
        }
      return json.decode(response.body);
      //Aqui está retornando todo minha API em Json
  }

  //O initState() ajudar a printa os dados no console antes de ir para o app
  @override
  void initState()
  {
    super.initState();
    _getSech().then((value)
    {
      print(value);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(//o AppBar é meu cabeçalho do app,
      backgroundColor: Colors.black,
      title: Image.network("http://i.picasion.com/gl/90/d2QO.gif"),
      //O image.network além de carregar imagem ele consegue carregar gif
      centerTitle: true,
      ),
      backgroundColor: Colors.black,
      //Sempre que tive uma coisa em cima da outra chama o Column
      //body é o corpo do meu app
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text)
              {
                setState(() {
                  _serch = text;
                  _ofSet = 0;
                });
              },//sERVE PARA PESQUISA
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getSech(),
                builder: (context, snapshot)//Função anonima que vai conter a mensagem de arquivo carregando
                {
                  switch(snapshot.connectionState)
                  {
                    case ConnectionState.waiting: //caso ele esteja carregando
                    case ConnectionState.none://caso ele não tenha nada para carregar
                  //Aqui vai aparecer um circulo que vai rodar, muito bacana
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          //Animação da cor sempre parada no app, no caso branco
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError)
                      return Container();
                      else return _CarregandoGifs(context, snapshot);
                  }
                }
            ),
          ),
        ],
      ),
    );//O scaffold serve para fazer o cabeçalho do app.
  }
  int _carregarMaisGif(List data)
  {
    if(_serch == null)
      return data.length;
    else
      return data.length + 1;
  }
  Widget _CarregandoGifs(BuildContext context, AsyncSnapshot snapshot)
  {
      return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
        itemCount: _carregarMaisGif(snapshot.data["data"]),
        itemBuilder: (context, index)
        {
          if(snapshot == null || index < snapshot.data["data"].length)
          {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              //Pegando o caminho da minha url da API
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Gifs(snapshot.data["data"][index])),

                  //O navigator faz a troca de paginas
                );
              },
              onLongPress: ()
              {
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
                //Poder compartilhar o gif
              },
            );
          }
          else
            {
              return Container(
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white, size: 70.0),
                      Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                    ],
                  ),
                  onTap: ()
                  {
                    setState(() {
                      _ofSet +=19;
                    });
                  },
                ),
              );
            }
          //Perimitir eu clickar na imagem e ela ampliar
        },
      );
  }


}
