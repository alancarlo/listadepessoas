import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/model/ListPersonModel.dart';
import 'package:money_search/model/MoneyModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}
/// instancia do modelo para receber as informações

class _HomeViewState extends State<HomeView> {
  List<ListPersonModel> model = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Busca de Moedas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: FutureBuilder<List<ListPersonModel>>(
          ///future: local onde informções serão buscadas
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
            return ListView.builder(
              itemCount: model.length,
              
              itemBuilder: (context, index) {
                ListPersonModel item =model [index];
                return ListTile(
                  leading: Image.network(item.avatar ?? ""),
                  title: Text(item.name ?? ""),
                  trailing: Text(item.id ?? ""),)
                  ;
              },);
          }
        ));
  }
 }

