import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_users/main.dart';

class EditPage extends StatefulWidget {
   const EditPage({super.key, required this.userDetails});
    final DocumentSnapshot userDetails;
  
 @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final db = FirebaseFirestore.instance;
  late TextEditingController nameUserController;
  late TextEditingController emailController;
  late TextEditingController urlAvatarController;

  @override
  void initState() {
    super.initState();
    nameUserController = TextEditingController(text: widget.userDetails['nameUser']);
    emailController = TextEditingController(text: widget.userDetails['email']);
    urlAvatarController = TextEditingController(text: widget.userDetails['urlAvatar']);
  }

  @override
  void dispose() {
    nameUserController.dispose();
    emailController.dispose();
    urlAvatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Editar Usuário'),
      ),
      body: Container(
        width: 450,
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameUserController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: urlAvatarController,
                decoration: const InputDecoration(labelText: 'Avatar URL'),
              ),
              const SizedBox(height: 16),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await db
            .collection("users")
            .doc(widget.userDetails.id)
            .update({ 
              'nameUser': nameUserController.text, 
              'email': emailController.text, 
              'urlAvatar': urlAvatarController.text});

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Editado com sucesso!')));
              
              Navigator.pop(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Lista de usuários')));
              
        },
        child: const Icon(Icons.save_rounded),
      ),
    );
  }
}