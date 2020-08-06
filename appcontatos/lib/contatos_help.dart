import 'package:sqflite/sqflite.dart';//Importando o SQL
import "package:sqflite/sql.dart";//Importa o sql

import 'package:path/path.dart';//Aqui importa o JOIN do SQL

//Sempre que utilizar o final do lado de uma variavel
//Não vai poder alterar mais a variavel
final String contactTable = "contactTable";//Variavel global do bd

final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

//A classe a seguir usar um padrao de apenas um objeto,
class ContatoHelp
{
  static final ContatoHelp _instancia = ContatoHelp.internal();//Criando obj da propria classe
  factory ContatoHelp() => _instancia;//chamo o objeto
  ContatoHelp.internal();
  Database _db;//Apenas a classe ContatoHelp pode acessar o banco de dados

//Sempre que quiser pegar o banco de dados usar-se get db{}
  Future<Database> get db async{
    if(_db!= null)
      {
        return _db;
      }
    else {
      _db = await initDb();
      return _db;
    }
  }
  //Craidno banco
  Future<Database> initDb() async
  {
    final databasesPath = await getDatabasesPath();//ELE RETORNA O BD, MAS DEMORARR UM POUQUINHO
    final path = join(databasesPath, "ContactNEW.db");//Aqui estou declarando o banco de dados
    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion)//Aqui estou abrindo o banco de dados
    async {
      await db.execute
        ("CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, "
          "$emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
      );//Executnado banco de dados
    });
  }
  //Salvando contatos
  Future<Contatos> saveContact(Contatos contatos) async{
    Database dbContatos = await db;//Chamando o banco de dados

    contatos.id = await dbContatos.insert(contactTable, contatos.toMap());
    //Salbando no banco de dados
    return contatos;//Retornando o banco de dados
  }
  //Salvando contatos em map
  Future<Contatos> getContatos(int id ) async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    List<Map> maps = await dbContatos.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn], //Query é uma pesquisa no BD
    where:"$idColumn = ?", whereArgs: [id]);//Aqui vai busca pelo id o contato
    if(maps.length > 0)//Se tiver algum contato no bd
    {
      return Contatos.fromMap(maps.first);//Vou pegar o contato
    }
    else return null;
  }
  //Deletando os contatos
  Future<int> deletContact(int id ) async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    return await dbContatos.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);//Achando o contato a ser deletado
  }
  //Atualizando os contatos
  Future<int> updateContato(Contatos contact ) async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    return await dbContatos.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }
  //Retornando a quantidade de contatos adicionados
  Future<int> getNumber() async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    return Sqflite.firstIntValue(await dbContatos.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }
  //FECHANDO O BANCO DE DADOS
  Future close() async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    dbContatos.close();
  }


  Future<List> getObterTodosContatos() async
  {
    Database dbContatos = await db;//Chamando o banco de dados
    List listMap = await dbContatos.rawQuery("SELECT * FROM $contactTable");
    List<Contatos> listContatos = List();
    for(Map map in listMap)
    {
      listContatos.add(Contatos.fromMap(map));
    }
    return listContatos;
  }
}
//Tabela
//id nome email phone img

class Contatos
{
  Contatos() {}
  int id;
  String name;
  String email;
  String phone;
  String img;
  //Pegando de mapa passando para meu contato
  Contatos.fromMap(Map map)
  {
    //Pegando a tabela com Maps
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }
  //Pegando de contato passando para o mapa
  Map toMap()
  {
    Map<String, dynamic> map =
    {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(idColumn != null || idColumn.isEmpty)
    {
      map[idColumn] = id;
    }
    return map;
  }
  @override
  String toString() {
    // TODO: implement toString
    return "Contact: $id, Name: $name, Email: $email, Phone: $phone, img: $img";
  }
}