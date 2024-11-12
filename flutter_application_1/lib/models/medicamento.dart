class Medicamento {
  final int? id;
  final String nome;
  final String dosagem;
  final String frequencia;

  Medicamento({
    this.id,
    required this.nome,
    required this.dosagem,
    required this.frequencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dosagem': dosagem,
      'frequencia': frequencia,
    };
  }

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      id: map['id'],
      nome: map['nome'],
      dosagem: map['dosagem'],
      frequencia: map['frequencia'],
    );
  }
} 