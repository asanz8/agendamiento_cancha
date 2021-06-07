class Agenda {
  final int id;
  final String cancha;
  final String usuario;
  final int fecha;
  final double probLluvia;

  Agenda({
    required this.id,
    required this.cancha,
    required this.usuario,
    required this.fecha,
    required this.probLluvia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cancha': cancha,
      'usuario': usuario,
      'fecha': fecha,
      'probLluvia': probLluvia,
    };
  }

  @override
  String toString() {
    return 'Agenda{id: $id, cancha: $cancha, usuario: $usuario, fecha: $fecha, probLluvia: $probLluvia}';
  }
}