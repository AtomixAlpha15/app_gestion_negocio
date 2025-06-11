import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Copia la imagen seleccionada por el usuario a la carpeta de imágenes de la app.
/// Devuelve la nueva ruta completa.
Future<String> guardarImagenEnAppDir(String origenPath, String clienteId) async {
  final appDir = await getApplicationDocumentsDirectory();
  final imagenesDir = Directory(p.join(appDir.path, 'imagenes_clientes'));
  if (!await imagenesDir.exists()) {
    await imagenesDir.create(recursive: true);
  }
  // Le ponemos un nombre único basado en el id del cliente y la extensión original
  final ext = p.extension(origenPath);
  final destinoPath = p.join(imagenesDir.path, '$clienteId$ext');
  await File(origenPath).copy(destinoPath);
  return destinoPath;
}
