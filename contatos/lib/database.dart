import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:contatos/contato.dart';

class ConectarDatabase {
  Database? bancodeDados;

  Future<Database> abrirBanco() async {
    if (bancodeDados != null) {
      return bancodeDados!;
    }

    /// /data/user/0/com.seuapp/databases/
    final caminho = join(await getDatabasesPath(), 'contato.db');
    bancodeDados = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE contatos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT,
            telefone TEXT,
            status INTEGER
          )
  ''');
      },
    );
    return bancodeDados!;
  }

  Future<List<Contato>> obterContatos() async {
    final db = await abrirBanco();
    final List<Map<String, dynamic>> dados = await db.query('contatos');
    final lista = dados.map((item) => Contato.fromMap(item)).toList();
    return lista;
  }

  Future<int> inserirContato(Contato contato) async {
    final db = await abrirBanco();
    return await db.insert('contatos', contato.toMap());
  }

  Future<int> atualizarContato(Contato contato) async {
    final db = await abrirBanco();
    return await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> excluirContato(int id) async {
    final db = await abrirBanco();
    return await db.delete('contatos', where: 'id = ?', whereArgs: [id]);
  }
}
