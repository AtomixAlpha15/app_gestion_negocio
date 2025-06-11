class Cliente {
  final String id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? notas;
  final String? imagenPath; // Añade la ruta local de la imagen

  Cliente({
    required this.id,
    required this.nombre,
    this.telefono,
    this.email,
    this.notas,
    this.imagenPath,
  });
}
