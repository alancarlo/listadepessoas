import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/api.dart';
import 'package:money_search/data/cache.dart';
import 'package:money_search/data/internet.dart';
import 'package:money_search/data/string.dart';
import 'package:money_search/model/ListPersonModel.dart';
import 'package:money_search/model/MoneyModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// instancia do modelo para receber as informações

class _HomeViewState extends State<HomeView> {
  checkConnection() async {
    internet = await CheckInternet().checkConnection();
    if (internet == false) {
      readMemory();
    }
    setState(() {});
  }

  bool internet = true;

  @override
  initState() {
    checkConnection();
    super.initState();
  }

  List<ListPersonModel> model = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: [
            Visibility(
                visible: internet == false,
                child: Icon(Icons.network_cell_outlined))
          ],
        ),
        body: internet == false
            ? ListView.builder(
                itemCount: model.length,
                itemBuilder: (context, index) {
                  ListPersonModel item = model[index];
                  return ListTile(
                    leading: Image.network(
                        errorBuilder: (context, error, stackTrace) {
                      return Container();
                    }, item.avatar ?? ""),
                    title: Text(item.name ?? ""),
                    trailing: Text(item.id ?? ""),
                  );
                },
              )
            : FutureBuilder<List<ListPersonModel>>(

                ///future: local onde informações serão buscadas
                future: MoneyController().getListPerson(),
                builder: (context, snapshot) {
                  /// validação de carregamento da conexão
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// validação de erro
                  if (snapshot.error == true) {
                    return SizedBox(
                      height: 300,
                      child: Text("Vazio"),
                    );
                  }

                  /// passando informações para o modelo criado
                  model = snapshot.data ?? model;
                  model.sort(
                    (a, b) => a.name!.compareTo(b.name!),
                  );

                  model.removeWhere((pessoa) => pessoa.id == "64");

                  model.forEach((pessoa) {
                    if (pessoa.id == "9") {
                      pessoa.avatar == null;
                      // pessoa.avatar == "";
                    }
                  });
                  model.forEach((pessoa) {
                    if (pessoa.id == "9") {
                      pessoa.avatar ==
                          "https://pbs.twimg.com/profile_images/473478169614233600/Rsk4QfHT_400x400.jpeg";
                      // pessoa.avatar == "";
                    }
                  });
                  model.add(ListPersonModel(
                    avatar:
                        "https://pbs.twimg.com/profile_images/420370594/IMG_3253_400x400.JPG",
                    id: "99",
                    name: "Arnaldo",
                  ));
                  return ListView.builder(
                    itemCount: model.length,
                    itemBuilder: (context, index) {
                      ListPersonModel item = model[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: "http://via.placeholder.com/350x150",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        // Image.network(
                        //     errorBuilder: (context, error, stackTrace) {
                        //   return Container();
                        // }, item.avatar ?? ""),
                        title: Text(item.name ?? ""),
                        trailing: Text(item.id ?? ""),
                      );
                    },
                  );
                }));
  }

  verifyData(AsyncSnapshot snapshot) async {
    try {
      model.addAll(snapshot.data ?? []);
      await SecureStorage()
          .writeSecureData(pessoas, json.encode(snapshot.data));
    } catch (e) {
      print("erro ao salvar lista");
    }
  }

  readMemory() async {
    var result = await SecureStorage().readSecureData(pessoas);
    if (result == null) return;
    List<ListPersonModel> lista = (json.decode(result) as List)
        .map((e) => ListPersonModel.fromJson(e))
        .toList();
    model.addAll(lista);
  }

  Future<Null> refresh() async {
    setState(() {});
  }
}
