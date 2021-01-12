import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Crianca.dart';

List<Crianca> dataModel;

class ListaCrianca extends StatefulWidget {
  @override
  _ListaCriancaState createState() => _ListaCriancaState();
}

class _ListaCriancaState extends State<ListaCrianca> {
  TextEditingController nome, dataNasc, sexo, descricao;
  String id;

  @override
  void initState() {
    super.initState();
    nome = new TextEditingController();
    dataNasc = new TextEditingController();
    sexo = new TextEditingController();
    descricao = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListData(),
      ),
    );
  }

  Widget ListData() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 15, left: 20, right: 10, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: FutureBuilder(
          future: getData(),
          builder: (context, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.builder(
                itemCount: dataModel.length,
                itemBuilder: (context, pos) {
                  return ListTile(
                    leading: Text(
                      dataModel[pos].nome,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(
                      dataModel[pos].dataNasc,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      dataModel[pos].sexo,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      id = dataModel[pos].id;
                      nome.text = dataModel[pos].nome;
                      dataNasc.text = dataModel[pos].dataNasc;
                      sexo.text = dataModel[pos].sexo;
                      descricao.text = dataModel[pos].descricao;

                      showDialog(
                          context: context,
                          builder: (context) => updateDialog(id));
                    },

                    onLongPress: (){
                      showDialog(context: context, builder: (context) => deleteDialog(dataModel[pos].id));
                    },

                  );
                });
          }),
    );
  }

  Widget updateDialog(String id) {
    return AlertDialog(
      title: Text("Editar dados"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: nome,
            ),
            TextField(
              controller: dataNasc,
            ),
            TextField(
              controller: sexo,
            ),
            TextField(
              controller: descricao,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            updateData(id, nome.text, dataNasc.text, sexo.text, descricao.text);
          },
          child: Text("Atualizar"),
        )
      ],
    );
  }

  Widget deleteDialog(String id) {
    return AlertDialog(
      title: Text("Excluir?"),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            deleteData(id);
          },
          child: Text("Excluir"),
        )
      ],
    );
  }

  Future<List> getData() async {
    var url = "http://10.0.0.106/pdm/selectCrianca.php";
    http.Response res = await http.get(url);
    var data = jsonDecode(res.body);
    dataModel = new List();
    for (var word in data['result']) {
      String id = word['id'];
      String nome = word['nome'];
      String dataNasc = word['dataNasc'];
      String sexo = word['sexo'];
      String descricao = word['descricao'];
      dataModel.add(new Crianca(id, nome, dataNasc, sexo, descricao));
    }
    return dataModel;
  }

  void updateData(String id, String nome, String dataNasc, String sexo,
      String descricao) async {
    var url = "http://10.0.0.106/pdm/updateCrianca.php";

    var data = {
      "_id": id,
      "nome": nome,
      "dataNasc": dataNasc,
      "sexo": sexo,
      "descricao": descricao
    };
    var res = await http.post(url, body: data);
  }
  
  void deleteData(String id) async{
    var url = "http://10.0.0.106/pdm/deleteCrianca.php";
    var data = {
      "_id": id
    };
    var res = await http.post(url, body: data);
  }

}
