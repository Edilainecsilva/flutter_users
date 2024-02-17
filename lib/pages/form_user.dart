import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_users/main.dart';
import 'package:flutter_users/models/user_model.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final db = FirebaseFirestore.instance;

  TextEditingController nameUserController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController urlAvatarController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameUserController,
              decoration: const InputDecoration(hintText: 'Nome: '),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'E-mail: '),
            ),
            TextField(
              controller: urlAvatarController,
              decoration: const InputDecoration(hintText: 'URL do avatar: '),
            ),
            
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        var user = UserModel( 
          nameUser: nameUserController.text, 
          email: emailController.text, 
          urlAvatar: urlAvatarController.text);
          await db
            .collection("users")
            .add(user.toJson());
            Navigator.pop(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Lista de usuários')));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário adicionado com sucesso!')));
        },
        child: const Icon(Icons.save_rounded),),
    );
  }
}