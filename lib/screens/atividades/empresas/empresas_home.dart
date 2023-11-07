import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas.dart';
import 'package:flutter_application_1/screens/atividades/empresas/empresas_add.dart';
import 'package:flutter_application_1/models/pessoas.dart';
import 'package:flutter_application_1/database/pessoas.dart';

class EmpresasHome extends StatefulWidget {
  const EmpresasHome({Key? key}) : super(key: key);

  @override
  State<EmpresasHome> createState() => _EmpresasHomeState();
}

class _EmpresasHomeState extends State<EmpresasHome> {
  final List<String> empresasNomes = [];
  final List<String> empresasUid = [];
  final List<String> funcionariosUid = [];

  bool _isLoading = true;

  String usuarioLogado = "";

  void _getDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Pessoas pessoas = Pessoas(); // Crie uma instância da classe Pessoas
    Pessoa pessoa = await pessoas.getUserSession();
    setState(() {
      if (auth.currentUser != null) {
        usuarioLogado = pessoa.id;
      }
    });
    setState(() {
      _isLoading = false;
    });
  }

  void _getEmpresas() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot empresasSnapshot = await db.collection("empresas").get();

    if (empresasSnapshot.docs.isNotEmpty) {
      empresasNomes.clear(); // Limpar a lista antes de adicionar os novos itens

      List<Future<void>> futures = [];

      for (QueryDocumentSnapshot doc in empresasSnapshot.docs) {
        var empresaData = doc.data() as Map<String, dynamic>;
        var nomeDaEmpresa = empresaData["nome"];
        var uidEmpresa = doc.id;

        var funcionariosRefs = empresaData["funcionarios"] as List<dynamic>;
        for (var funcionarioRef in funcionariosRefs) {
          DocumentReference funcionarioDocRef = funcionarioRef;
          futures.add(funcionarioDocRef.get().then((funcionarioSnapshot) {
            if (funcionarioSnapshot.exists) {
              var uidFuncionario = funcionarioSnapshot.id;
              if (uidFuncionario == usuarioLogado) {
                setState(() {
                  funcionariosUid.add(uidFuncionario);
                });
                setState(() {
                  empresasNomes.add(nomeDaEmpresa);
                });
                setState(() {
                  empresasUid.add(uidEmpresa);
                });
              }
            }
          }));
        }
      }

      // Esperar até que todas as consultas sejam concluídas
      await Future.wait(futures);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDados();
    _getEmpresas();
     // Chama a função ao entrar na tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          if (_isLoading) const CircularProgressIndicator(),
          if (!_isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: empresasNomes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Empresas(
                              empresaUid: empresasUid[index],
                            ),
                          ),
                        );
                      },
                      child: Text(empresasNomes[index]),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmpresasAdd(
                                userId: usuarioLogado,
                              )));
                },
                child: const Icon(Icons.add)),
          )
        ],
      ),
    );
  }
}