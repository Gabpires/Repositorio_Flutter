import 'package:contatos/contato.dart';
import 'package:flutter/material.dart';
import 'package:contatos/database.dart';

class Exibecontato extends StatefulWidget {
  const Exibecontato({super.key});

  @override
  State<Exibecontato> createState() => _ExibecontatoState();
}

class _ExibecontatoState extends State<Exibecontato> {
  ConectarDatabase database = ConectarDatabase();
  List<Contato> _contatosSalvos = [];

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  void _carregarContatos() async {
    final contatos = await database.obterContatos();
    setState(() {
      _contatosSalvos = contatos;
      print(_contatosSalvos);
    });
  }

  //FORMULÁRIO DE CADASTRO
  void _abrirFormulario(Contato contato) {
    bool edicao = contato.id != null;
    final _nomeController = TextEditingController(text: contato?.nome ?? '');
    final _emailController = TextEditingController(text: contato.email ?? '');
    final _telefoneController = TextEditingController(
      text: contato.telefone ?? '',
    );
    final int status = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(edicao ? "Editar contato" : "Cadastro contato"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _telefoneController,
                  decoration: InputDecoration(labelText: 'Telefone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final dadosContato = Contato(
                  id: contato.id,
                  nome: _nomeController.text,
                  email: _emailController.text,
                  telefone: _telefoneController.text,
                  status: 0,
                );
                _salvarContato(dadosContato);
              },
              child: Text(edicao ? 'Atualizar' : 'Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _salvarContato(Contato contato) async {
    bool modoEdicao = contato.id != null;
    int id = 0;
    if (contato.id == null) {
      id = await database.inserirContato(contato);
    } else {
      id = await database.atualizarContato(contato);
    }

    //int id = await database.inserirContato(contato);
    //int(id);
    Navigator.of(context).pop();
    _carregarContatos();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          contato.id == null ? 'Contato atualizado' : "Contato Salvo",
        ),
      ),
    );
  }

  void confirmarExclusao(Contato contato) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('confirmar exclusão'),
          content: Text(
            'Tem certeza que deseja excluir o contato, não há volta',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('não'),
            ),
            TextButton(
              onPressed: () async {
                _executarExclusao(contato.id!);
                Navigator.pop(context);
              },
              child: Text('sim'),
            ),
          ],
        );
      },
    );
  }

  void _executarExclusao(int id) async {
    await ConectarDatabase().excluirContato(id);
    _carregarContatos();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Contato excluído!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Contatos")),
      body: ListView.builder(
        itemCount: _contatosSalvos.length,
        itemBuilder: (context, index) {
          final contato = _contatosSalvos[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(contato.nome),
              subtitle: Text('Email: ${contato.email} - ${contato.telefone}'),
              leading: CircleAvatar(child: Icon(Icons.person)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _abrirFormulario(contato),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => confirmarExclusao(contato),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormulario(Contato(nome: '', telefone: ''));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
