import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/api.dart';
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
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: FutureBuilder<List<ListPersonModel>>(
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
            model.sort((a, b) => a.name!.compareTo(b.name!),);
            
            model.removeWhere((pessoa) => pessoa.id == "64" );

            model.forEach((pessoa){
                if(pessoa.id == "9"){
                  pessoa.avatar == null;
                 // pessoa.avatar == "";
                }});
                 model.forEach((pessoa){
                if(pessoa.id == "9"){
                  pessoa.avatar == "https://pbs.twimg.com/profile_images/473478169614233600/Rsk4QfHT_400x400.jpeg";
                 // pessoa.avatar == "";
                }
            });
            model.add(ListPersonModel(avatar: "https://pbs.twimg.com/profile_images/420370594/IMG_3253_400x400.JPG",
            id:"99", 
            name: "Arnaldo",));
            return ListView.builder(
              itemCount: model.length,
              
              itemBuilder: (context, index) {
                ListPersonModel item =model [index];
                return ListTile(
                  leading: Image.network(
                    errorBuilder:(context, error, stackTrace) {
                  return Container();
                    },item.avatar ??""),
                  title: Text(item.name ?? ""),
                  trailing: Text(item.id ?? ""),);
              },);
          }
        ));
  }
 }

