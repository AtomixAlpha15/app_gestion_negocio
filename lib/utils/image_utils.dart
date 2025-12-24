import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Copia la imagen a una carpeta de la app.
/// - Si la imagen ya está dentro de esa carpeta, NO copia (devuelve el mismo path).
/// - Devuelve la nueva ruta completa.
Future<String> guardarImagenEnAppDir({
  required String origenPath,
  required String entidadId,        // clienteId o servicioId
  required String carpeta,          // 'imagenes_clientes' o 'imagenes_servicios'
}) async {
  final appDir = await getApplicationDocumentsDirectory();
  final imagenesDir = Directory(p.join(appDir.path, carpeta));

  if (!await imagenesDir.exists()) {
    await imagenesDir.create(recursive: true);
  }

  final normalizedSource = p.normalize(origenPath);
  final normalizedFolder = p.normalize(imagenesDir.path);

  // ✅ Si ya está en la carpeta destino, no copiamos
  if (p.isWithin(normalizedFolder, normalizedSource)) {
    return origenPath;
  }

  final ext = p.extension(origenPath).isNotEmpty ? p.extension(origenPath) : '.jpg';
  final destinoPath = p.join(imagenesDir.path, '$entidadId$ext');

  // ✅ Si por alguna razón origen y destino son el mismo fichero
  if (p.equals(normalizedSource, p.normalize(destinoPath))) {
    return destinoPath;
  }

  await File(origenPath).copy(destinoPath);
  return destinoPath;
}
