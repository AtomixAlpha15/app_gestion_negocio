import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../providers/settings_provider.dart';
import 'app_database.dart';

class BackupService {
  final AppDatabase db;
  final SettingsProvider settings;

  BackupService({required this.db, required this.settings});

  /// EXPORTA: settings.json + manifest.json + (logo) + (db física)
  Future<String?> exportFullBackup() async {
    final String? destPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar copia de seguridad',
      fileName: 'backup_empresa.zip',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (destPath == null) return null;

    final tmpDir = await getTemporaryDirectory();
    final workDir = Directory(p.join(tmpDir.path, 'backup_work'));
    if (workDir.existsSync()) await workDir.delete(recursive: true);
    await workDir.create(recursive: true);

    // 1) settings.json
    final settingsMap = settings.toBackupMap();
    await File(p.join(workDir.path, 'settings.json'))
        .writeAsString(jsonEncode(settingsMap));

    // 2) manifest.json
    final manifest = {
      'version': 1,
      'generatedAt': DateTime.now().toIso8601String(),
      'platform': defaultTargetPlatform.toString(),
    };
    await File(p.join(workDir.path, 'manifest.json'))
        .writeAsString(jsonEncode(manifest));

    // 3) logo (opcional)
    if (settings.logoPath.isNotEmpty && File(settings.logoPath).existsSync()) {
      final src = File(settings.logoPath);
      await src.copy(p.join(workDir.path, p.basename(src.path)));
    }

    // 4) DB física (usando la ruta real expuesta por AppDatabase)
    try {
      final dbFile = await db.getDatabaseFile();
      if (await dbFile.exists()) {
        await dbFile.copy(p.join(workDir.path, p.basename(dbFile.path)));
      }
    } catch (e) {
      debugPrint('No se pudo incluir la DB en el backup: $e');
    }

    // 5) empaquetar ZIP
    final encoder = ZipFileEncoder();
    encoder.create(destPath);
    for (final f in workDir.listSync()) {
      if (f is File) encoder.addFile(f);
    }
    encoder.close();

    await workDir.delete(recursive: true);
    return destPath;
  }

  /// IMPORTA: settings.json (+logo) (+db) y sobreescribe la DB tras cerrarla.
  /// Devuelve true si el proceso terminó (puede requerir reinicio).
  Future<bool> importFullBackup() async {
    final picked = await FilePicker.platform.pickFiles(
      dialogTitle: 'Seleccionar copia de seguridad',
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (picked == null || picked.files.single.path == null) return false;

    final zipPath = picked.files.single.path!;
    final tmpDir = await getTemporaryDirectory();
    final extractDir = Directory(p.join(tmpDir.path, 'backup_in'));
    if (extractDir.existsSync()) await extractDir.delete(recursive: true);
    await extractDir.create(recursive: true);

    // Extraer
    try {
      final bytes = await File(zipPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final f in archive) {
        final outPath = p.join(extractDir.path, f.name);
        if (f.isFile) {
          final outFile = File(outPath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(f.content as List<int>);
        } else {
          await Directory(outPath).create(recursive: true);
        }
      }
    } catch (e) {
      debugPrint('Error al descomprimir ZIP: $e');
      return false;
    }

    // settings.json obligatorio
    final settingsFile = File(p.join(extractDir.path, 'settings.json'));
    if (!settingsFile.existsSync()) {
      debugPrint('settings.json no encontrado');
      await extractDir.delete(recursive: true);
      return false;
    }

    // Resolver docs app
    final docs = await getApplicationDocumentsDirectory();

    // 1) Logo (opcional)
    final Map<String, dynamic> sMap =
        jsonDecode(await settingsFile.readAsString()) as Map<String, dynamic>;
    String? overrideLogoPath;
    final logoFileName = (sMap['logoFile'] ?? '') as String;
    if (logoFileName.isNotEmpty) {
      final extractedLogo = File(p.join(extractDir.path, logoFileName));
      if (await extractedLogo.exists()) {
        final dst = File(p.join(docs.path, logoFileName));
        await extractedLogo.copy(dst.path);
        overrideLogoPath = dst.path;
      }
    }

    // 2) Aplicar ajustes (persiste y notifica)
    await settings.applyBackupMap(sMap, overrideLogoPath: overrideLogoPath);

    // 3) DB (opcional): si viene, cerrar la DB y sobreescribir
    final extractedDb = await _findDbIn(extractDir);
    if (extractedDb != null && await extractedDb.exists()) {
      try {
        final target = await db.getDatabaseFile(); // ruta REAL
        await db.closeDatabase();                   // <- CERRAR CONEXIÓN
        await extractedDb.copy(target.path);        // <- SOBREESCRIBIR
      } catch (e) {
        debugPrint('No se pudo restaurar la DB (bloqueo/permiso): $e');
        // copia de cortesía para restauración manual
        final fallback = File(p.join(docs.path, 'restaurar_${p.basename(extractedDb.path)}'));
        await extractedDb.copy(fallback.path);
      }
    }

    await extractDir.delete(recursive: true);
    return true;
  }

  // Busca un archivo con pinta de DB en la carpeta extraída
  Future<File?> _findDbIn(Directory dir) async {
    for (final f in dir.listSync()) {
      if (f is File) {
        final name = p.basename(f.path).toLowerCase();
        if (name.endsWith('.db') || name.endsWith('.sqlite')) return f;
      }
    }
    return null;
  }
  Future<void> autoBackupIfDue() async {
    final now = DateTime.now();
    final last = settings.ultimaFechaBackup;
    final interval = settings.intervaloBackupDias;

    final needs = last == null || now.difference(last).inDays >= interval;
    if (!needs) return;

    // Carpeta de Backups locales
    final docs = await getApplicationDocumentsDirectory();
    final backupsDir = Directory(p.join(docs.path, 'Backups'));
    if (!backupsDir.existsSync()) backupsDir.createSync(recursive: true);

    final fileName =
        'backup_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}.zip';
    final destPath = p.join(backupsDir.path, fileName);

    // Reutilizamos la lógica de export, pero escribiendo directo (sin diálogo)
    final tmpDir = await getTemporaryDirectory();
    final workDir = Directory(p.join(tmpDir.path, 'backup_work_autosave'));
    if (workDir.existsSync()) await workDir.delete(recursive: true);
    await workDir.create(recursive: true);

    // settings.json
    await File(p.join(workDir.path, 'settings.json'))
        .writeAsString(jsonEncode(settings.toBackupMap()));

    // manifest.json
    final manifest = {
      'version': 1,
      'generatedAt': DateTime.now().toIso8601String(),
      'auto': true,
    };
    await File(p.join(workDir.path, 'manifest.json'))
        .writeAsString(jsonEncode(manifest));

    // logo (si existe)
    if (settings.logoPath.isNotEmpty && File(settings.logoPath).existsSync()) {
      await File(settings.logoPath)
          .copy(p.join(workDir.path, p.basename(settings.logoPath)));
    }

    // DB real
    try {
      final dbFile = await db.getDatabaseFile();
      if (await dbFile.exists()) {
        await dbFile.copy(p.join(workDir.path, p.basename(dbFile.path)));
      }
    } catch (_) {}

    // empaquetar
    final encoder = ZipFileEncoder();
    encoder.create(destPath);
    for (final f in workDir.listSync()) {
      if (f is File) encoder.addFile(f);
    }
    encoder.close();
    await workDir.delete(recursive: true);

    // marca la fecha
    settings.setUltimaFechaBackup(now);
  }

}
