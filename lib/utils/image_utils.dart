import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
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

/// Comprime la imagen a máx 800×800 JPEG al 80% y devuelve el base64.
/// Devuelve null si el archivo no existe o no se puede decodificar.
Future<String?> compressImageToBase64(String filePath) async {
  try {
    final file = File(filePath);
    if (!await file.exists()) return null;

    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;

    final img.Image resized;
    if (decoded.width > 800 || decoded.height > 800) {
      // Reduce la dimensión mayor a 800 manteniendo proporción
      if (decoded.width >= decoded.height) {
        resized = img.copyResize(decoded, width: 800);
      } else {
        resized = img.copyResize(decoded, height: 800);
      }
    } else {
      resized = decoded;
    }

    final jpgBytes = img.encodeJpg(resized, quality: 80);
    return base64Encode(jpgBytes);
  } catch (_) {
    return null;
  }
}

/// Decodifica un base64 de imagen y lo guarda como .jpg en el directorio dado.
/// Devuelve la ruta del archivo guardado, o null si el base64 está vacío.
Future<String?> saveBase64AsImage(
  String base64Data,
  String entityId,
  Directory dir,
) async {
  if (base64Data.isEmpty) return null;
  try {
    if (!await dir.exists()) await dir.create(recursive: true);
    final bytes = base64Decode(base64Data);
    final filePath = p.join(dir.path, '$entityId.jpg');
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  } catch (_) {
    return null;
  }
}
