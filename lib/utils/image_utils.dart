import 'dart:io';
import 'package:path/path.dart' as p;

/// Copia la imagen al directorio destino indicado.
/// Si ya está dentro de ese directorio, NO copia (devuelve el mismo path).
/// Devuelve la nueva ruta completa.
Future<String> guardarImagenEnAppDir({
  required String origenPath,
  required String entidadId,
  required Directory targetDir,
}) async {
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  final normalizedSource = p.normalize(origenPath);
  final normalizedFolder = p.normalize(targetDir.path);

  if (p.isWithin(normalizedFolder, normalizedSource)) {
    return origenPath;
  }

  final ext = p.extension(origenPath).isNotEmpty ? p.extension(origenPath) : '.jpg';
  final destinoPath = p.join(targetDir.path, '$entidadId$ext');

  if (p.equals(normalizedSource, p.normalize(destinoPath))) {
    return destinoPath;
  }

  await File(origenPath).copy(destinoPath);
  return destinoPath;
}
