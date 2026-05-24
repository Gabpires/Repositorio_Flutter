class Contato {
  final int? id;
  final String nome;
  final String telefone;
  final String? email;
  final int? status;

  Contato({
    this.id,
    required this.nome,
    required this.telefone,
    this.email,
    this.status
  });

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      status: map['status'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'status': status
    };
  }
}