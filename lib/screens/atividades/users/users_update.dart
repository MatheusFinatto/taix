import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pessoas.dart';

class UsersUpdate extends StatefulWidget {
  const UsersUpdate({super.key});

  @override
  State<UsersUpdate> createState() => _UsersUpdateState();
}

class _UsersUpdateState extends State<UsersUpdate> {
  String _id = "1";
  String _cpf = "";
  String _nome = "";
  String _endereco = "";
  String _telefone = "";
  String _email = "";

  TextEditingController _idController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _updateUser(String id, String cpf, String nome, String endereco,
      String telefone, String email) {
    // Funcão de update no Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Usuário"),
        backgroundColor: const Color.fromARGB(255, 88, 150, 237),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: "CPF",
                ),
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                ),
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: "Endereço",
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: "Telefone",
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 20), // Espaço entre os campos
              ElevatedButton(
                  onPressed: () {
                    _updateUser(
                        _idController.text,
                        _cpfController.text,
                        _nomeController.text,
                        _enderecoController.text,
                        _telefoneController.text,
                        _emailController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 88, 150, 237)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Atualizar Usuário")],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
