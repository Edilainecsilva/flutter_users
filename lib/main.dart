import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_users/firebase_options.dart';
import 'package:flutter_users/pages/edit_user.dart';
import 'package:flutter_users/pages/form_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Crud ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de usuários'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Conexão com o banco de dados
  final db = FirebaseFirestore.instance;

  //Função para carregar url Avatar 
  CircleAvatar circleAvatar(String url) {
    return (Uri.tryParse(url)!.isAbsolute) ?
       CircleAvatar(backgroundImage: NetworkImage(url))
       : const CircleAvatar(child: Icon(Icons.person));
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        width: 350,
        margin: const EdgeInsets.all(20.0),
        
        child: StreamBuilder<QuerySnapshot>(
          //Ligação com o Firebase
          stream: db.collection("users").snapshots(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              List usersList = snapshot.data!.docs;
              return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index){
                  DocumentSnapshot document = usersList[index];
                  
        
                  Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String id = document.id;
                    String nameUser = data ['nameUser'];
                    String email = data ['email'];
                    String urlAvatar = data ['urlAvatar'];
        
                  return ListTile(
                    leading: circleAvatar(urlAvatar),
                    title: Text(nameUser),
                    subtitle: Text(email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      //Butão para editar User
                      IconButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(userDetails: document
                          ,)));
                        }, 
                        icon: const Icon(Icons.edit), color: Colors.blue),
                      
                      //Butão para excluir User
                      IconButton(
                        onPressed: () async {
                          showDialog(context: context, 
                          builder: (context) => AlertDialog(
                            title: const Text('Excluir'),
                            content: const Text('Confima a Exclusão?'),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.of(context).pop();
                              }, child: const Text('Não',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                              TextButton(onPressed: () async{
                                await db
                                .collection("users")
                                .doc(document.id)
                                .delete();
                                Navigator.of(context).pop();
                              }, child: const Text('Sim',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),))
                            ],
                            backgroundColor: Theme.of(context).colorScheme.onPrimary,
                          ));
                        }, 
                        icon: const Icon(Icons.delete), color: Colors.red,),
                    ],
                  ),
                );
              });
            } else {
                return const Text("Lista vazia! Por favor adicione usuários");
            }
          },
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FormPage()));
        },
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }
}