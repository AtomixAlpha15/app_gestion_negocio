// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagenPathMeta =
      const VerificationMeta('imagenPath');
  @override
  late final GeneratedColumn<String> imagenPath = GeneratedColumn<String>(
      'imagen_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        telefono,
        email,
        notas,
        imagenPath,
        createdAt,
        updatedAt,
        syncId,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(Insertable<Cliente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('imagen_path')) {
      context.handle(
          _imagenPathMeta,
          imagenPath.isAcceptableOrUnknown(
              data['imagen_path']!, _imagenPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      imagenPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imagen_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final String id;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? notas;
  final String? imagenPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const Cliente(
      {required this.id,
      required this.nombre,
      this.telefono,
      this.email,
      this.notas,
      this.imagenPath,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || imagenPath != null) {
      map['imagen_path'] = Variable<String>(imagenPath);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      imagenPath: imagenPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagenPath),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      notas: serializer.fromJson<String?>(json['notas']),
      imagenPath: serializer.fromJson<String?>(json['imagenPath']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'notas': serializer.toJson<String?>(notas),
      'imagenPath': serializer.toJson<String?>(imagenPath),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Cliente copyWith(
          {String? id,
          String? nombre,
          Value<String?> telefono = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          Value<String?> imagenPath = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      Cliente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        telefono: telefono.present ? telefono.value : this.telefono,
        email: email.present ? email.value : this.email,
        notas: notas.present ? notas.value : this.notas,
        imagenPath: imagenPath.present ? imagenPath.value : this.imagenPath,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      notas: data.notas.present ? data.notas.value : this.notas,
      imagenPath:
          data.imagenPath.present ? data.imagenPath.value : this.imagenPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('notas: $notas, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono, email, notas,
      imagenPath, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.notas == this.notas &&
          other.imagenPath == this.imagenPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> notas;
  final Value<String?> imagenPath;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre);
  static Insertable<Cliente> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? notas,
    Expression<String>? imagenPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (notas != null) 'notas': notas,
      if (imagenPath != null) 'imagen_path': imagenPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<String?>? telefono,
      Value<String?>? email,
      Value<String?>? notas,
      Value<String?>? imagenPath,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      notas: notas ?? this.notas,
      imagenPath: imagenPath ?? this.imagenPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (imagenPath.present) {
      map['imagen_path'] = Variable<String>(imagenPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('notas: $notas, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiciosTable extends Servicios
    with TableInfo<$ServiciosTable, Servicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _duracionMinutosMeta =
      const VerificationMeta('duracionMinutos');
  @override
  late final GeneratedColumn<int> duracionMinutos = GeneratedColumn<int>(
      'duracion_minutos', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagenPathMeta =
      const VerificationMeta('imagenPath');
  @override
  late final GeneratedColumn<String> imagenPath = GeneratedColumn<String>(
      'imagen_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        precio,
        duracionMinutos,
        descripcion,
        imagenPath,
        createdAt,
        updatedAt,
        syncId,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servicios';
  @override
  VerificationContext validateIntegrity(Insertable<Servicio> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('duracion_minutos')) {
      context.handle(
          _duracionMinutosMeta,
          duracionMinutos.isAcceptableOrUnknown(
              data['duracion_minutos']!, _duracionMinutosMeta));
    } else if (isInserting) {
      context.missing(_duracionMinutosMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    }
    if (data.containsKey('imagen_path')) {
      context.handle(
          _imagenPathMeta,
          imagenPath.isAcceptableOrUnknown(
              data['imagen_path']!, _imagenPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Servicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Servicio(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      duracionMinutos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duracion_minutos'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion']),
      imagenPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}imagen_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $ServiciosTable createAlias(String alias) {
    return $ServiciosTable(attachedDatabase, alias);
  }
}

class Servicio extends DataClass implements Insertable<Servicio> {
  final String id;
  final String nombre;
  final double precio;
  final int duracionMinutos;
  final String? descripcion;
  final String? imagenPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const Servicio(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.duracionMinutos,
      this.descripcion,
      this.imagenPath,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    map['duracion_minutos'] = Variable<int>(duracionMinutos);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || imagenPath != null) {
      map['imagen_path'] = Variable<String>(imagenPath);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ServiciosCompanion toCompanion(bool nullToAbsent) {
    return ServiciosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      precio: Value(precio),
      duracionMinutos: Value(duracionMinutos),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      imagenPath: imagenPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagenPath),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory Servicio.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Servicio(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precio: serializer.fromJson<double>(json['precio']),
      duracionMinutos: serializer.fromJson<int>(json['duracionMinutos']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      imagenPath: serializer.fromJson<String?>(json['imagenPath']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'precio': serializer.toJson<double>(precio),
      'duracionMinutos': serializer.toJson<int>(duracionMinutos),
      'descripcion': serializer.toJson<String?>(descripcion),
      'imagenPath': serializer.toJson<String?>(imagenPath),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Servicio copyWith(
          {String? id,
          String? nombre,
          double? precio,
          int? duracionMinutos,
          Value<String?> descripcion = const Value.absent(),
          Value<String?> imagenPath = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      Servicio(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        precio: precio ?? this.precio,
        duracionMinutos: duracionMinutos ?? this.duracionMinutos,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
        imagenPath: imagenPath.present ? imagenPath.value : this.imagenPath,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  Servicio copyWithCompanion(ServiciosCompanion data) {
    return Servicio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
      duracionMinutos: data.duracionMinutos.present
          ? data.duracionMinutos.value
          : this.duracionMinutos,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      imagenPath:
          data.imagenPath.present ? data.imagenPath.value : this.imagenPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servicio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('duracionMinutos: $duracionMinutos, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, precio, duracionMinutos,
      descripcion, imagenPath, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servicio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.duracionMinutos == this.duracionMinutos &&
          other.descripcion == this.descripcion &&
          other.imagenPath == this.imagenPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class ServiciosCompanion extends UpdateCompanion<Servicio> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<int> duracionMinutos;
  final Value<String?> descripcion;
  final Value<String?> imagenPath;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ServiciosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.duracionMinutos = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiciosCompanion.insert({
    required String id,
    required String nombre,
    required double precio,
    required int duracionMinutos,
    this.descripcion = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre),
        precio = Value(precio),
        duracionMinutos = Value(duracionMinutos);
  static Insertable<Servicio> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<double>? precio,
    Expression<int>? duracionMinutos,
    Expression<String>? descripcion,
    Expression<String>? imagenPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (duracionMinutos != null) 'duracion_minutos': duracionMinutos,
      if (descripcion != null) 'descripcion': descripcion,
      if (imagenPath != null) 'imagen_path': imagenPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiciosCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<double>? precio,
      Value<int>? duracionMinutos,
      Value<String?>? descripcion,
      Value<String?>? imagenPath,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return ServiciosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      descripcion: descripcion ?? this.descripcion,
      imagenPath: imagenPath ?? this.imagenPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (duracionMinutos.present) {
      map['duracion_minutos'] = Variable<int>(duracionMinutos.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (imagenPath.present) {
      map['imagen_path'] = Variable<String>(imagenPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiciosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('duracionMinutos: $duracionMinutos, ')
          ..write('descripcion: $descripcion, ')
          ..write('imagenPath: $imagenPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitasTable extends Citas with TableInfo<$CitasTable, Cita> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clientes (id)'));
  static const VerificationMeta _servicioIdMeta =
      const VerificationMeta('servicioId');
  @override
  late final GeneratedColumn<String> servicioId = GeneratedColumn<String>(
      'servicio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES servicios (id)'));
  static const VerificationMeta _inicioMeta = const VerificationMeta('inicio');
  @override
  late final GeneratedColumn<DateTime> inicio = GeneratedColumn<DateTime>(
      'inicio', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _finMeta = const VerificationMeta('fin');
  @override
  late final GeneratedColumn<DateTime> fin = GeneratedColumn<DateTime>(
      'fin', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pagadaMeta = const VerificationMeta('pagada');
  @override
  late final GeneratedColumn<bool> pagada = GeneratedColumn<bool>(
      'pagada', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pagada" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _metodoPagoMeta =
      const VerificationMeta('metodoPago');
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
      'metodo_pago', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clienteId,
        servicioId,
        inicio,
        fin,
        precio,
        pagada,
        metodoPago,
        notas,
        createdAt,
        updatedAt,
        syncId,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'citas';
  @override
  VerificationContext validateIntegrity(Insertable<Cita> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('servicio_id')) {
      context.handle(
          _servicioIdMeta,
          servicioId.isAcceptableOrUnknown(
              data['servicio_id']!, _servicioIdMeta));
    } else if (isInserting) {
      context.missing(_servicioIdMeta);
    }
    if (data.containsKey('inicio')) {
      context.handle(_inicioMeta,
          inicio.isAcceptableOrUnknown(data['inicio']!, _inicioMeta));
    } else if (isInserting) {
      context.missing(_inicioMeta);
    }
    if (data.containsKey('fin')) {
      context.handle(
          _finMeta, fin.isAcceptableOrUnknown(data['fin']!, _finMeta));
    } else if (isInserting) {
      context.missing(_finMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('pagada')) {
      context.handle(_pagadaMeta,
          pagada.isAcceptableOrUnknown(data['pagada']!, _pagadaMeta));
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
          _metodoPagoMeta,
          metodoPago.isAcceptableOrUnknown(
              data['metodo_pago']!, _metodoPagoMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cita map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cita(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cliente_id'])!,
      servicioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}servicio_id'])!,
      inicio: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}inicio'])!,
      fin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fin'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      pagada: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pagada'])!,
      metodoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo_pago']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $CitasTable createAlias(String alias) {
    return $CitasTable(attachedDatabase, alias);
  }
}

class Cita extends DataClass implements Insertable<Cita> {
  final String id;
  final String clienteId;
  final String servicioId;
  final DateTime inicio;
  final DateTime fin;
  final double precio;
  final bool pagada;
  final String? metodoPago;
  final String? notas;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const Cita(
      {required this.id,
      required this.clienteId,
      required this.servicioId,
      required this.inicio,
      required this.fin,
      required this.precio,
      required this.pagada,
      this.metodoPago,
      this.notas,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['servicio_id'] = Variable<String>(servicioId);
    map['inicio'] = Variable<DateTime>(inicio);
    map['fin'] = Variable<DateTime>(fin);
    map['precio'] = Variable<double>(precio);
    map['pagada'] = Variable<bool>(pagada);
    if (!nullToAbsent || metodoPago != null) {
      map['metodo_pago'] = Variable<String>(metodoPago);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  CitasCompanion toCompanion(bool nullToAbsent) {
    return CitasCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      servicioId: Value(servicioId),
      inicio: Value(inicio),
      fin: Value(fin),
      precio: Value(precio),
      pagada: Value(pagada),
      metodoPago: metodoPago == null && nullToAbsent
          ? const Value.absent()
          : Value(metodoPago),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory Cita.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cita(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      servicioId: serializer.fromJson<String>(json['servicioId']),
      inicio: serializer.fromJson<DateTime>(json['inicio']),
      fin: serializer.fromJson<DateTime>(json['fin']),
      precio: serializer.fromJson<double>(json['precio']),
      pagada: serializer.fromJson<bool>(json['pagada']),
      metodoPago: serializer.fromJson<String?>(json['metodoPago']),
      notas: serializer.fromJson<String?>(json['notas']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'servicioId': serializer.toJson<String>(servicioId),
      'inicio': serializer.toJson<DateTime>(inicio),
      'fin': serializer.toJson<DateTime>(fin),
      'precio': serializer.toJson<double>(precio),
      'pagada': serializer.toJson<bool>(pagada),
      'metodoPago': serializer.toJson<String?>(metodoPago),
      'notas': serializer.toJson<String?>(notas),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Cita copyWith(
          {String? id,
          String? clienteId,
          String? servicioId,
          DateTime? inicio,
          DateTime? fin,
          double? precio,
          bool? pagada,
          Value<String?> metodoPago = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      Cita(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        servicioId: servicioId ?? this.servicioId,
        inicio: inicio ?? this.inicio,
        fin: fin ?? this.fin,
        precio: precio ?? this.precio,
        pagada: pagada ?? this.pagada,
        metodoPago: metodoPago.present ? metodoPago.value : this.metodoPago,
        notas: notas.present ? notas.value : this.notas,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  Cita copyWithCompanion(CitasCompanion data) {
    return Cita(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      servicioId:
          data.servicioId.present ? data.servicioId.value : this.servicioId,
      inicio: data.inicio.present ? data.inicio.value : this.inicio,
      fin: data.fin.present ? data.fin.value : this.fin,
      precio: data.precio.present ? data.precio.value : this.precio,
      pagada: data.pagada.present ? data.pagada.value : this.pagada,
      metodoPago:
          data.metodoPago.present ? data.metodoPago.value : this.metodoPago,
      notas: data.notas.present ? data.notas.value : this.notas,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cita(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('servicioId: $servicioId, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('precio: $precio, ')
          ..write('pagada: $pagada, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('notas: $notas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clienteId, servicioId, inicio, fin,
      precio, pagada, metodoPago, notas, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cita &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.servicioId == this.servicioId &&
          other.inicio == this.inicio &&
          other.fin == this.fin &&
          other.precio == this.precio &&
          other.pagada == this.pagada &&
          other.metodoPago == this.metodoPago &&
          other.notas == this.notas &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class CitasCompanion extends UpdateCompanion<Cita> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> servicioId;
  final Value<DateTime> inicio;
  final Value<DateTime> fin;
  final Value<double> precio;
  final Value<bool> pagada;
  final Value<String?> metodoPago;
  final Value<String?> notas;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const CitasCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fin = const Value.absent(),
    this.precio = const Value.absent(),
    this.pagada = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.notas = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitasCompanion.insert({
    required String id,
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    this.pagada = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.notas = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        clienteId = Value(clienteId),
        servicioId = Value(servicioId),
        inicio = Value(inicio),
        fin = Value(fin),
        precio = Value(precio);
  static Insertable<Cita> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? servicioId,
    Expression<DateTime>? inicio,
    Expression<DateTime>? fin,
    Expression<double>? precio,
    Expression<bool>? pagada,
    Expression<String>? metodoPago,
    Expression<String>? notas,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (servicioId != null) 'servicio_id': servicioId,
      if (inicio != null) 'inicio': inicio,
      if (fin != null) 'fin': fin,
      if (precio != null) 'precio': precio,
      if (pagada != null) 'pagada': pagada,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (notas != null) 'notas': notas,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitasCompanion copyWith(
      {Value<String>? id,
      Value<String>? clienteId,
      Value<String>? servicioId,
      Value<DateTime>? inicio,
      Value<DateTime>? fin,
      Value<double>? precio,
      Value<bool>? pagada,
      Value<String?>? metodoPago,
      Value<String?>? notas,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return CitasCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      servicioId: servicioId ?? this.servicioId,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      precio: precio ?? this.precio,
      pagada: pagada ?? this.pagada,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (servicioId.present) {
      map['servicio_id'] = Variable<String>(servicioId.value);
    }
    if (inicio.present) {
      map['inicio'] = Variable<DateTime>(inicio.value);
    }
    if (fin.present) {
      map['fin'] = Variable<DateTime>(fin.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (pagada.present) {
      map['pagada'] = Variable<bool>(pagada.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitasCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('servicioId: $servicioId, ')
          ..write('inicio: $inicio, ')
          ..write('fin: $fin, ')
          ..write('precio: $precio, ')
          ..write('pagada: $pagada, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('notas: $notas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtrasServicioTable extends ExtrasServicio
    with TableInfo<$ExtrasServicioTable, ExtrasServicioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtrasServicioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servicioIdMeta =
      const VerificationMeta('servicioId');
  @override
  late final GeneratedColumn<String> servicioId = GeneratedColumn<String>(
      'servicio_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES servicios (id)'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, servicioId, nombre, precio, createdAt, updatedAt, syncId, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extras_servicio';
  @override
  VerificationContext validateIntegrity(Insertable<ExtrasServicioData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('servicio_id')) {
      context.handle(
          _servicioIdMeta,
          servicioId.isAcceptableOrUnknown(
              data['servicio_id']!, _servicioIdMeta));
    } else if (isInserting) {
      context.missing(_servicioIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExtrasServicioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtrasServicioData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      servicioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}servicio_id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $ExtrasServicioTable createAlias(String alias) {
    return $ExtrasServicioTable(attachedDatabase, alias);
  }
}

class ExtrasServicioData extends DataClass
    implements Insertable<ExtrasServicioData> {
  final String id;
  final String servicioId;
  final String nombre;
  final double precio;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const ExtrasServicioData(
      {required this.id,
      required this.servicioId,
      required this.nombre,
      required this.precio,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['servicio_id'] = Variable<String>(servicioId);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ExtrasServicioCompanion toCompanion(bool nullToAbsent) {
    return ExtrasServicioCompanion(
      id: Value(id),
      servicioId: Value(servicioId),
      nombre: Value(nombre),
      precio: Value(precio),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory ExtrasServicioData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtrasServicioData(
      id: serializer.fromJson<String>(json['id']),
      servicioId: serializer.fromJson<String>(json['servicioId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precio: serializer.fromJson<double>(json['precio']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'servicioId': serializer.toJson<String>(servicioId),
      'nombre': serializer.toJson<String>(nombre),
      'precio': serializer.toJson<double>(precio),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ExtrasServicioData copyWith(
          {String? id,
          String? servicioId,
          String? nombre,
          double? precio,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      ExtrasServicioData(
        id: id ?? this.id,
        servicioId: servicioId ?? this.servicioId,
        nombre: nombre ?? this.nombre,
        precio: precio ?? this.precio,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  ExtrasServicioData copyWithCompanion(ExtrasServicioCompanion data) {
    return ExtrasServicioData(
      id: data.id.present ? data.id.value : this.id,
      servicioId:
          data.servicioId.present ? data.servicioId.value : this.servicioId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasServicioData(')
          ..write('id: $id, ')
          ..write('servicioId: $servicioId, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, servicioId, nombre, precio, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtrasServicioData &&
          other.id == this.id &&
          other.servicioId == this.servicioId &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class ExtrasServicioCompanion extends UpdateCompanion<ExtrasServicioData> {
  final Value<String> id;
  final Value<String> servicioId;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ExtrasServicioCompanion({
    this.id = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtrasServicioCompanion.insert({
    required String id,
    required String servicioId,
    required String nombre,
    required double precio,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        servicioId = Value(servicioId),
        nombre = Value(nombre),
        precio = Value(precio);
  static Insertable<ExtrasServicioData> custom({
    Expression<String>? id,
    Expression<String>? servicioId,
    Expression<String>? nombre,
    Expression<double>? precio,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (servicioId != null) 'servicio_id': servicioId,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtrasServicioCompanion copyWith(
      {Value<String>? id,
      Value<String>? servicioId,
      Value<String>? nombre,
      Value<double>? precio,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return ExtrasServicioCompanion(
      id: id ?? this.id,
      servicioId: servicioId ?? this.servicioId,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (servicioId.present) {
      map['servicio_id'] = Variable<String>(servicioId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasServicioCompanion(')
          ..write('id: $id, ')
          ..write('servicioId: $servicioId, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExtrasCitaTable extends ExtrasCita
    with TableInfo<$ExtrasCitaTable, ExtrasCitaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExtrasCitaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _citaIdMeta = const VerificationMeta('citaId');
  @override
  late final GeneratedColumn<String> citaId = GeneratedColumn<String>(
      'cita_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES citas (id)'));
  static const VerificationMeta _extraIdMeta =
      const VerificationMeta('extraId');
  @override
  late final GeneratedColumn<String> extraId = GeneratedColumn<String>(
      'extra_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES extras_servicio (id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [citaId, extraId, createdAt, updatedAt, syncId, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'extras_cita';
  @override
  VerificationContext validateIntegrity(Insertable<ExtrasCitaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cita_id')) {
      context.handle(_citaIdMeta,
          citaId.isAcceptableOrUnknown(data['cita_id']!, _citaIdMeta));
    } else if (isInserting) {
      context.missing(_citaIdMeta);
    }
    if (data.containsKey('extra_id')) {
      context.handle(_extraIdMeta,
          extraId.isAcceptableOrUnknown(data['extra_id']!, _extraIdMeta));
    } else if (isInserting) {
      context.missing(_extraIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {citaId, extraId};
  @override
  ExtrasCitaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExtrasCitaData(
      citaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cita_id'])!,
      extraId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $ExtrasCitaTable createAlias(String alias) {
    return $ExtrasCitaTable(attachedDatabase, alias);
  }
}

class ExtrasCitaData extends DataClass implements Insertable<ExtrasCitaData> {
  final String citaId;
  final String extraId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const ExtrasCitaData(
      {required this.citaId,
      required this.extraId,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cita_id'] = Variable<String>(citaId);
    map['extra_id'] = Variable<String>(extraId);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ExtrasCitaCompanion toCompanion(bool nullToAbsent) {
    return ExtrasCitaCompanion(
      citaId: Value(citaId),
      extraId: Value(extraId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory ExtrasCitaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtrasCitaData(
      citaId: serializer.fromJson<String>(json['citaId']),
      extraId: serializer.fromJson<String>(json['extraId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'citaId': serializer.toJson<String>(citaId),
      'extraId': serializer.toJson<String>(extraId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ExtrasCitaData copyWith(
          {String? citaId,
          String? extraId,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      ExtrasCitaData(
        citaId: citaId ?? this.citaId,
        extraId: extraId ?? this.extraId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  ExtrasCitaData copyWithCompanion(ExtrasCitaCompanion data) {
    return ExtrasCitaData(
      citaId: data.citaId.present ? data.citaId.value : this.citaId,
      extraId: data.extraId.present ? data.extraId.value : this.extraId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasCitaData(')
          ..write('citaId: $citaId, ')
          ..write('extraId: $extraId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(citaId, extraId, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtrasCitaData &&
          other.citaId == this.citaId &&
          other.extraId == this.extraId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class ExtrasCitaCompanion extends UpdateCompanion<ExtrasCitaData> {
  final Value<String> citaId;
  final Value<String> extraId;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ExtrasCitaCompanion({
    this.citaId = const Value.absent(),
    this.extraId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtrasCitaCompanion.insert({
    required String citaId,
    required String extraId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : citaId = Value(citaId),
        extraId = Value(extraId);
  static Insertable<ExtrasCitaData> custom({
    Expression<String>? citaId,
    Expression<String>? extraId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (citaId != null) 'cita_id': citaId,
      if (extraId != null) 'extra_id': extraId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtrasCitaCompanion copyWith(
      {Value<String>? citaId,
      Value<String>? extraId,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return ExtrasCitaCompanion(
      citaId: citaId ?? this.citaId,
      extraId: extraId ?? this.extraId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (citaId.present) {
      map['cita_id'] = Variable<String>(citaId.value);
    }
    if (extraId.present) {
      map['extra_id'] = Variable<String>(extraId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasCitaCompanion(')
          ..write('citaId: $citaId, ')
          ..write('extraId: $extraId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GastosTable extends Gastos with TableInfo<$GastosTable, Gasto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GastosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conceptoMeta =
      const VerificationMeta('concepto');
  @override
  late final GeneratedColumn<String> concepto = GeneratedColumn<String>(
      'concepto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
      'precio', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, concepto, precio, fecha, createdAt, updatedAt, syncId, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gastos';
  @override
  VerificationContext validateIntegrity(Insertable<Gasto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('concepto')) {
      context.handle(_conceptoMeta,
          concepto.isAcceptableOrUnknown(data['concepto']!, _conceptoMeta));
    } else if (isInserting) {
      context.missing(_conceptoMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(_precioMeta,
          precio.isAcceptableOrUnknown(data['precio']!, _precioMeta));
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gasto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gasto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      concepto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}concepto'])!,
      precio: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $GastosTable createAlias(String alias) {
    return $GastosTable(attachedDatabase, alias);
  }
}

class Gasto extends DataClass implements Insertable<Gasto> {
  final String id;
  final String concepto;
  final double precio;
  final DateTime fecha;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const Gasto(
      {required this.id,
      required this.concepto,
      required this.precio,
      required this.fecha,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['concepto'] = Variable<String>(concepto);
    map['precio'] = Variable<double>(precio);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  GastosCompanion toCompanion(bool nullToAbsent) {
    return GastosCompanion(
      id: Value(id),
      concepto: Value(concepto),
      precio: Value(precio),
      fecha: Value(fecha),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory Gasto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gasto(
      id: serializer.fromJson<String>(json['id']),
      concepto: serializer.fromJson<String>(json['concepto']),
      precio: serializer.fromJson<double>(json['precio']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'concepto': serializer.toJson<String>(concepto),
      'precio': serializer.toJson<double>(precio),
      'fecha': serializer.toJson<DateTime>(fecha),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Gasto copyWith(
          {String? id,
          String? concepto,
          double? precio,
          DateTime? fecha,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      Gasto(
        id: id ?? this.id,
        concepto: concepto ?? this.concepto,
        precio: precio ?? this.precio,
        fecha: fecha ?? this.fecha,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  Gasto copyWithCompanion(GastosCompanion data) {
    return Gasto(
      id: data.id.present ? data.id.value : this.id,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      precio: data.precio.present ? data.precio.value : this.precio,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gasto(')
          ..write('id: $id, ')
          ..write('concepto: $concepto, ')
          ..write('precio: $precio, ')
          ..write('fecha: $fecha, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, concepto, precio, fecha, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gasto &&
          other.id == this.id &&
          other.concepto == this.concepto &&
          other.precio == this.precio &&
          other.fecha == this.fecha &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class GastosCompanion extends UpdateCompanion<Gasto> {
  final Value<String> id;
  final Value<String> concepto;
  final Value<double> precio;
  final Value<DateTime> fecha;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const GastosCompanion({
    this.id = const Value.absent(),
    this.concepto = const Value.absent(),
    this.precio = const Value.absent(),
    this.fecha = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GastosCompanion.insert({
    required String id,
    required String concepto,
    required double precio,
    this.fecha = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        concepto = Value(concepto),
        precio = Value(precio);
  static Insertable<Gasto> custom({
    Expression<String>? id,
    Expression<String>? concepto,
    Expression<double>? precio,
    Expression<DateTime>? fecha,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concepto != null) 'concepto': concepto,
      if (precio != null) 'precio': precio,
      if (fecha != null) 'fecha': fecha,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GastosCompanion copyWith(
      {Value<String>? id,
      Value<String>? concepto,
      Value<double>? precio,
      Value<DateTime>? fecha,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return GastosCompanion(
      id: id ?? this.id,
      concepto: concepto ?? this.concepto,
      precio: precio ?? this.precio,
      fecha: fecha ?? this.fecha,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (concepto.present) {
      map['concepto'] = Variable<String>(concepto.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GastosCompanion(')
          ..write('id: $id, ')
          ..write('concepto: $concepto, ')
          ..write('precio: $precio, ')
          ..write('fecha: $fecha, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BonosTable extends Bonos with TableInfo<$BonosTable, Bono> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _servicioIdMeta =
      const VerificationMeta('servicioId');
  @override
  late final GeneratedColumn<String> servicioId = GeneratedColumn<String>(
      'servicio_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Bono'));
  static const VerificationMeta _sesionesTotalesMeta =
      const VerificationMeta('sesionesTotales');
  @override
  late final GeneratedColumn<int> sesionesTotales = GeneratedColumn<int>(
      'sesiones_totales', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sesionesUsadasMeta =
      const VerificationMeta('sesionesUsadas');
  @override
  late final GeneratedColumn<int> sesionesUsadas = GeneratedColumn<int>(
      'sesiones_usadas', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _precioBonoMeta =
      const VerificationMeta('precioBono');
  @override
  late final GeneratedColumn<double> precioBono = GeneratedColumn<double>(
      'precio_bono', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _compradoElMeta =
      const VerificationMeta('compradoEl');
  @override
  late final GeneratedColumn<DateTime> compradoEl = GeneratedColumn<DateTime>(
      'comprado_el', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _caducaElMeta =
      const VerificationMeta('caducaEl');
  @override
  late final GeneratedColumn<DateTime> caducaEl = GeneratedColumn<DateTime>(
      'caduca_el', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _creadoElMeta =
      const VerificationMeta('creadoEl');
  @override
  late final GeneratedColumn<DateTime> creadoEl = GeneratedColumn<DateTime>(
      'creado_el', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _reconocimientoMeta =
      const VerificationMeta('reconocimiento');
  @override
  late final GeneratedColumn<String> reconocimiento = GeneratedColumn<String>(
      'reconocimiento', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('prorrateado'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clienteId,
        servicioId,
        nombre,
        sesionesTotales,
        sesionesUsadas,
        precioBono,
        compradoEl,
        caducaEl,
        activo,
        creadoEl,
        reconocimiento,
        createdAt,
        updatedAt,
        syncId,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bonos';
  @override
  VerificationContext validateIntegrity(Insertable<Bono> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('servicio_id')) {
      context.handle(
          _servicioIdMeta,
          servicioId.isAcceptableOrUnknown(
              data['servicio_id']!, _servicioIdMeta));
    } else if (isInserting) {
      context.missing(_servicioIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    }
    if (data.containsKey('sesiones_totales')) {
      context.handle(
          _sesionesTotalesMeta,
          sesionesTotales.isAcceptableOrUnknown(
              data['sesiones_totales']!, _sesionesTotalesMeta));
    } else if (isInserting) {
      context.missing(_sesionesTotalesMeta);
    }
    if (data.containsKey('sesiones_usadas')) {
      context.handle(
          _sesionesUsadasMeta,
          sesionesUsadas.isAcceptableOrUnknown(
              data['sesiones_usadas']!, _sesionesUsadasMeta));
    }
    if (data.containsKey('precio_bono')) {
      context.handle(
          _precioBonoMeta,
          precioBono.isAcceptableOrUnknown(
              data['precio_bono']!, _precioBonoMeta));
    }
    if (data.containsKey('comprado_el')) {
      context.handle(
          _compradoElMeta,
          compradoEl.isAcceptableOrUnknown(
              data['comprado_el']!, _compradoElMeta));
    }
    if (data.containsKey('caduca_el')) {
      context.handle(_caducaElMeta,
          caducaEl.isAcceptableOrUnknown(data['caduca_el']!, _caducaElMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('creado_el')) {
      context.handle(_creadoElMeta,
          creadoEl.isAcceptableOrUnknown(data['creado_el']!, _creadoElMeta));
    }
    if (data.containsKey('reconocimiento')) {
      context.handle(
          _reconocimientoMeta,
          reconocimiento.isAcceptableOrUnknown(
              data['reconocimiento']!, _reconocimientoMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bono map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bono(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cliente_id'])!,
      servicioId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}servicio_id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      sesionesTotales: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sesiones_totales'])!,
      sesionesUsadas: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sesiones_usadas'])!,
      precioBono: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio_bono']),
      compradoEl: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}comprado_el'])!,
      caducaEl: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}caduca_el']),
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      creadoEl: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}creado_el'])!,
      reconocimiento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reconocimiento'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $BonosTable createAlias(String alias) {
    return $BonosTable(attachedDatabase, alias);
  }
}

class Bono extends DataClass implements Insertable<Bono> {
  final String id;
  final String clienteId;
  final String servicioId;
  final String nombre;
  final int sesionesTotales;
  final int sesionesUsadas;
  final double? precioBono;
  final DateTime compradoEl;
  final DateTime? caducaEl;
  final bool activo;
  final DateTime creadoEl;
  final String reconocimiento;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const Bono(
      {required this.id,
      required this.clienteId,
      required this.servicioId,
      required this.nombre,
      required this.sesionesTotales,
      required this.sesionesUsadas,
      this.precioBono,
      required this.compradoEl,
      this.caducaEl,
      required this.activo,
      required this.creadoEl,
      required this.reconocimiento,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['servicio_id'] = Variable<String>(servicioId);
    map['nombre'] = Variable<String>(nombre);
    map['sesiones_totales'] = Variable<int>(sesionesTotales);
    map['sesiones_usadas'] = Variable<int>(sesionesUsadas);
    if (!nullToAbsent || precioBono != null) {
      map['precio_bono'] = Variable<double>(precioBono);
    }
    map['comprado_el'] = Variable<DateTime>(compradoEl);
    if (!nullToAbsent || caducaEl != null) {
      map['caduca_el'] = Variable<DateTime>(caducaEl);
    }
    map['activo'] = Variable<bool>(activo);
    map['creado_el'] = Variable<DateTime>(creadoEl);
    map['reconocimiento'] = Variable<String>(reconocimiento);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BonosCompanion toCompanion(bool nullToAbsent) {
    return BonosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      servicioId: Value(servicioId),
      nombre: Value(nombre),
      sesionesTotales: Value(sesionesTotales),
      sesionesUsadas: Value(sesionesUsadas),
      precioBono: precioBono == null && nullToAbsent
          ? const Value.absent()
          : Value(precioBono),
      compradoEl: Value(compradoEl),
      caducaEl: caducaEl == null && nullToAbsent
          ? const Value.absent()
          : Value(caducaEl),
      activo: Value(activo),
      creadoEl: Value(creadoEl),
      reconocimiento: Value(reconocimiento),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory Bono.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bono(
      id: serializer.fromJson<String>(json['id']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      servicioId: serializer.fromJson<String>(json['servicioId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      sesionesTotales: serializer.fromJson<int>(json['sesionesTotales']),
      sesionesUsadas: serializer.fromJson<int>(json['sesionesUsadas']),
      precioBono: serializer.fromJson<double?>(json['precioBono']),
      compradoEl: serializer.fromJson<DateTime>(json['compradoEl']),
      caducaEl: serializer.fromJson<DateTime?>(json['caducaEl']),
      activo: serializer.fromJson<bool>(json['activo']),
      creadoEl: serializer.fromJson<DateTime>(json['creadoEl']),
      reconocimiento: serializer.fromJson<String>(json['reconocimiento']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clienteId': serializer.toJson<String>(clienteId),
      'servicioId': serializer.toJson<String>(servicioId),
      'nombre': serializer.toJson<String>(nombre),
      'sesionesTotales': serializer.toJson<int>(sesionesTotales),
      'sesionesUsadas': serializer.toJson<int>(sesionesUsadas),
      'precioBono': serializer.toJson<double?>(precioBono),
      'compradoEl': serializer.toJson<DateTime>(compradoEl),
      'caducaEl': serializer.toJson<DateTime?>(caducaEl),
      'activo': serializer.toJson<bool>(activo),
      'creadoEl': serializer.toJson<DateTime>(creadoEl),
      'reconocimiento': serializer.toJson<String>(reconocimiento),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Bono copyWith(
          {String? id,
          String? clienteId,
          String? servicioId,
          String? nombre,
          int? sesionesTotales,
          int? sesionesUsadas,
          Value<double?> precioBono = const Value.absent(),
          DateTime? compradoEl,
          Value<DateTime?> caducaEl = const Value.absent(),
          bool? activo,
          DateTime? creadoEl,
          String? reconocimiento,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      Bono(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        servicioId: servicioId ?? this.servicioId,
        nombre: nombre ?? this.nombre,
        sesionesTotales: sesionesTotales ?? this.sesionesTotales,
        sesionesUsadas: sesionesUsadas ?? this.sesionesUsadas,
        precioBono: precioBono.present ? precioBono.value : this.precioBono,
        compradoEl: compradoEl ?? this.compradoEl,
        caducaEl: caducaEl.present ? caducaEl.value : this.caducaEl,
        activo: activo ?? this.activo,
        creadoEl: creadoEl ?? this.creadoEl,
        reconocimiento: reconocimiento ?? this.reconocimiento,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  Bono copyWithCompanion(BonosCompanion data) {
    return Bono(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      servicioId:
          data.servicioId.present ? data.servicioId.value : this.servicioId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      sesionesTotales: data.sesionesTotales.present
          ? data.sesionesTotales.value
          : this.sesionesTotales,
      sesionesUsadas: data.sesionesUsadas.present
          ? data.sesionesUsadas.value
          : this.sesionesUsadas,
      precioBono:
          data.precioBono.present ? data.precioBono.value : this.precioBono,
      compradoEl:
          data.compradoEl.present ? data.compradoEl.value : this.compradoEl,
      caducaEl: data.caducaEl.present ? data.caducaEl.value : this.caducaEl,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEl: data.creadoEl.present ? data.creadoEl.value : this.creadoEl,
      reconocimiento: data.reconocimiento.present
          ? data.reconocimiento.value
          : this.reconocimiento,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bono(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('servicioId: $servicioId, ')
          ..write('nombre: $nombre, ')
          ..write('sesionesTotales: $sesionesTotales, ')
          ..write('sesionesUsadas: $sesionesUsadas, ')
          ..write('precioBono: $precioBono, ')
          ..write('compradoEl: $compradoEl, ')
          ..write('caducaEl: $caducaEl, ')
          ..write('activo: $activo, ')
          ..write('creadoEl: $creadoEl, ')
          ..write('reconocimiento: $reconocimiento, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      clienteId,
      servicioId,
      nombre,
      sesionesTotales,
      sesionesUsadas,
      precioBono,
      compradoEl,
      caducaEl,
      activo,
      creadoEl,
      reconocimiento,
      createdAt,
      updatedAt,
      syncId,
      deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bono &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.servicioId == this.servicioId &&
          other.nombre == this.nombre &&
          other.sesionesTotales == this.sesionesTotales &&
          other.sesionesUsadas == this.sesionesUsadas &&
          other.precioBono == this.precioBono &&
          other.compradoEl == this.compradoEl &&
          other.caducaEl == this.caducaEl &&
          other.activo == this.activo &&
          other.creadoEl == this.creadoEl &&
          other.reconocimiento == this.reconocimiento &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class BonosCompanion extends UpdateCompanion<Bono> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> servicioId;
  final Value<String> nombre;
  final Value<int> sesionesTotales;
  final Value<int> sesionesUsadas;
  final Value<double?> precioBono;
  final Value<DateTime> compradoEl;
  final Value<DateTime?> caducaEl;
  final Value<bool> activo;
  final Value<DateTime> creadoEl;
  final Value<String> reconocimiento;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const BonosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.sesionesTotales = const Value.absent(),
    this.sesionesUsadas = const Value.absent(),
    this.precioBono = const Value.absent(),
    this.compradoEl = const Value.absent(),
    this.caducaEl = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEl = const Value.absent(),
    this.reconocimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BonosCompanion.insert({
    required String id,
    required String clienteId,
    required String servicioId,
    this.nombre = const Value.absent(),
    required int sesionesTotales,
    this.sesionesUsadas = const Value.absent(),
    this.precioBono = const Value.absent(),
    this.compradoEl = const Value.absent(),
    this.caducaEl = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEl = const Value.absent(),
    this.reconocimiento = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        clienteId = Value(clienteId),
        servicioId = Value(servicioId),
        sesionesTotales = Value(sesionesTotales);
  static Insertable<Bono> custom({
    Expression<String>? id,
    Expression<String>? clienteId,
    Expression<String>? servicioId,
    Expression<String>? nombre,
    Expression<int>? sesionesTotales,
    Expression<int>? sesionesUsadas,
    Expression<double>? precioBono,
    Expression<DateTime>? compradoEl,
    Expression<DateTime>? caducaEl,
    Expression<bool>? activo,
    Expression<DateTime>? creadoEl,
    Expression<String>? reconocimiento,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (servicioId != null) 'servicio_id': servicioId,
      if (nombre != null) 'nombre': nombre,
      if (sesionesTotales != null) 'sesiones_totales': sesionesTotales,
      if (sesionesUsadas != null) 'sesiones_usadas': sesionesUsadas,
      if (precioBono != null) 'precio_bono': precioBono,
      if (compradoEl != null) 'comprado_el': compradoEl,
      if (caducaEl != null) 'caduca_el': caducaEl,
      if (activo != null) 'activo': activo,
      if (creadoEl != null) 'creado_el': creadoEl,
      if (reconocimiento != null) 'reconocimiento': reconocimiento,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BonosCompanion copyWith(
      {Value<String>? id,
      Value<String>? clienteId,
      Value<String>? servicioId,
      Value<String>? nombre,
      Value<int>? sesionesTotales,
      Value<int>? sesionesUsadas,
      Value<double?>? precioBono,
      Value<DateTime>? compradoEl,
      Value<DateTime?>? caducaEl,
      Value<bool>? activo,
      Value<DateTime>? creadoEl,
      Value<String>? reconocimiento,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return BonosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      servicioId: servicioId ?? this.servicioId,
      nombre: nombre ?? this.nombre,
      sesionesTotales: sesionesTotales ?? this.sesionesTotales,
      sesionesUsadas: sesionesUsadas ?? this.sesionesUsadas,
      precioBono: precioBono ?? this.precioBono,
      compradoEl: compradoEl ?? this.compradoEl,
      caducaEl: caducaEl ?? this.caducaEl,
      activo: activo ?? this.activo,
      creadoEl: creadoEl ?? this.creadoEl,
      reconocimiento: reconocimiento ?? this.reconocimiento,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (servicioId.present) {
      map['servicio_id'] = Variable<String>(servicioId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (sesionesTotales.present) {
      map['sesiones_totales'] = Variable<int>(sesionesTotales.value);
    }
    if (sesionesUsadas.present) {
      map['sesiones_usadas'] = Variable<int>(sesionesUsadas.value);
    }
    if (precioBono.present) {
      map['precio_bono'] = Variable<double>(precioBono.value);
    }
    if (compradoEl.present) {
      map['comprado_el'] = Variable<DateTime>(compradoEl.value);
    }
    if (caducaEl.present) {
      map['caduca_el'] = Variable<DateTime>(caducaEl.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (creadoEl.present) {
      map['creado_el'] = Variable<DateTime>(creadoEl.value);
    }
    if (reconocimiento.present) {
      map['reconocimiento'] = Variable<String>(reconocimiento.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BonosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('servicioId: $servicioId, ')
          ..write('nombre: $nombre, ')
          ..write('sesionesTotales: $sesionesTotales, ')
          ..write('sesionesUsadas: $sesionesUsadas, ')
          ..write('precioBono: $precioBono, ')
          ..write('compradoEl: $compradoEl, ')
          ..write('caducaEl: $caducaEl, ')
          ..write('activo: $activo, ')
          ..write('creadoEl: $creadoEl, ')
          ..write('reconocimiento: $reconocimiento, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BonoConsumosTable extends BonoConsumos
    with TableInfo<$BonoConsumosTable, BonoConsumo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonoConsumosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bonoIdMeta = const VerificationMeta('bonoId');
  @override
  late final GeneratedColumn<String> bonoId = GeneratedColumn<String>(
      'bono_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bonos (id)'));
  static const VerificationMeta _citaIdMeta = const VerificationMeta('citaId');
  @override
  late final GeneratedColumn<String> citaId = GeneratedColumn<String>(
      'cita_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES citas (id) ON DELETE CASCADE'));
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, bonoId, citaId, fecha, nota, createdAt, updatedAt, syncId, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bono_consumos';
  @override
  VerificationContext validateIntegrity(Insertable<BonoConsumo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bono_id')) {
      context.handle(_bonoIdMeta,
          bonoId.isAcceptableOrUnknown(data['bono_id']!, _bonoIdMeta));
    } else if (isInserting) {
      context.missing(_bonoIdMeta);
    }
    if (data.containsKey('cita_id')) {
      context.handle(_citaIdMeta,
          citaId.isAcceptableOrUnknown(data['cita_id']!, _citaIdMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BonoConsumo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BonoConsumo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bonoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bono_id'])!,
      citaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cita_id']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $BonoConsumosTable createAlias(String alias) {
    return $BonoConsumosTable(attachedDatabase, alias);
  }
}

class BonoConsumo extends DataClass implements Insertable<BonoConsumo> {
  final String id;
  final String bonoId;
  final String? citaId;
  final DateTime fecha;
  final String? nota;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const BonoConsumo(
      {required this.id,
      required this.bonoId,
      this.citaId,
      required this.fecha,
      this.nota,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bono_id'] = Variable<String>(bonoId);
    if (!nullToAbsent || citaId != null) {
      map['cita_id'] = Variable<String>(citaId);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BonoConsumosCompanion toCompanion(bool nullToAbsent) {
    return BonoConsumosCompanion(
      id: Value(id),
      bonoId: Value(bonoId),
      citaId:
          citaId == null && nullToAbsent ? const Value.absent() : Value(citaId),
      fecha: Value(fecha),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory BonoConsumo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BonoConsumo(
      id: serializer.fromJson<String>(json['id']),
      bonoId: serializer.fromJson<String>(json['bonoId']),
      citaId: serializer.fromJson<String?>(json['citaId']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String?>(json['nota']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bonoId': serializer.toJson<String>(bonoId),
      'citaId': serializer.toJson<String?>(citaId),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String?>(nota),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  BonoConsumo copyWith(
          {String? id,
          String? bonoId,
          Value<String?> citaId = const Value.absent(),
          DateTime? fecha,
          Value<String?> nota = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      BonoConsumo(
        id: id ?? this.id,
        bonoId: bonoId ?? this.bonoId,
        citaId: citaId.present ? citaId.value : this.citaId,
        fecha: fecha ?? this.fecha,
        nota: nota.present ? nota.value : this.nota,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  BonoConsumo copyWithCompanion(BonoConsumosCompanion data) {
    return BonoConsumo(
      id: data.id.present ? data.id.value : this.id,
      bonoId: data.bonoId.present ? data.bonoId.value : this.bonoId,
      citaId: data.citaId.present ? data.citaId.value : this.citaId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BonoConsumo(')
          ..write('id: $id, ')
          ..write('bonoId: $bonoId, ')
          ..write('citaId: $citaId, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, bonoId, citaId, fecha, nota, createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BonoConsumo &&
          other.id == this.id &&
          other.bonoId == this.bonoId &&
          other.citaId == this.citaId &&
          other.fecha == this.fecha &&
          other.nota == this.nota &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class BonoConsumosCompanion extends UpdateCompanion<BonoConsumo> {
  final Value<String> id;
  final Value<String> bonoId;
  final Value<String?> citaId;
  final Value<DateTime> fecha;
  final Value<String?> nota;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const BonoConsumosCompanion({
    this.id = const Value.absent(),
    this.bonoId = const Value.absent(),
    this.citaId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BonoConsumosCompanion.insert({
    required String id,
    required String bonoId,
    this.citaId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bonoId = Value(bonoId);
  static Insertable<BonoConsumo> custom({
    Expression<String>? id,
    Expression<String>? bonoId,
    Expression<String>? citaId,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bonoId != null) 'bono_id': bonoId,
      if (citaId != null) 'cita_id': citaId,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BonoConsumosCompanion copyWith(
      {Value<String>? id,
      Value<String>? bonoId,
      Value<String?>? citaId,
      Value<DateTime>? fecha,
      Value<String?>? nota,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return BonoConsumosCompanion(
      id: id ?? this.id,
      bonoId: bonoId ?? this.bonoId,
      citaId: citaId ?? this.citaId,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bonoId.present) {
      map['bono_id'] = Variable<String>(bonoId.value);
    }
    if (citaId.present) {
      map['cita_id'] = Variable<String>(citaId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BonoConsumosCompanion(')
          ..write('id: $id, ')
          ..write('bonoId: $bonoId, ')
          ..write('citaId: $citaId, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BonoPagosTable extends BonoPagos
    with TableInfo<$BonoPagosTable, BonoPago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonoPagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bonoIdMeta = const VerificationMeta('bonoId');
  @override
  late final GeneratedColumn<String> bonoId = GeneratedColumn<String>(
      'bono_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bonos (id)'));
  static const VerificationMeta _importeMeta =
      const VerificationMeta('importe');
  @override
  late final GeneratedColumn<double> importe = GeneratedColumn<double>(
      'importe', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _metodoMeta = const VerificationMeta('metodo');
  @override
  late final GeneratedColumn<String> metodo = GeneratedColumn<String>(
      'metodo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
      'sync_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bonoId,
        importe,
        metodo,
        fecha,
        nota,
        createdAt,
        updatedAt,
        syncId,
        deleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bono_pagos';
  @override
  VerificationContext validateIntegrity(Insertable<BonoPago> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bono_id')) {
      context.handle(_bonoIdMeta,
          bonoId.isAcceptableOrUnknown(data['bono_id']!, _bonoIdMeta));
    } else if (isInserting) {
      context.missing(_bonoIdMeta);
    }
    if (data.containsKey('importe')) {
      context.handle(_importeMeta,
          importe.isAcceptableOrUnknown(data['importe']!, _importeMeta));
    } else if (isInserting) {
      context.missing(_importeMeta);
    }
    if (data.containsKey('metodo')) {
      context.handle(_metodoMeta,
          metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('sync_id')) {
      context.handle(_syncIdMeta,
          syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BonoPago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BonoPago(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      bonoId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bono_id'])!,
      importe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}importe'])!,
      metodo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo']),
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      syncId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_id']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $BonoPagosTable createAlias(String alias) {
    return $BonoPagosTable(attachedDatabase, alias);
  }
}

class BonoPago extends DataClass implements Insertable<BonoPago> {
  final String id;
  final String bonoId;
  final double importe;
  final String? metodo;
  final DateTime fecha;
  final String? nota;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? syncId;
  final bool deleted;
  const BonoPago(
      {required this.id,
      required this.bonoId,
      required this.importe,
      this.metodo,
      required this.fecha,
      this.nota,
      this.createdAt,
      this.updatedAt,
      this.syncId,
      required this.deleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bono_id'] = Variable<String>(bonoId);
    map['importe'] = Variable<double>(importe);
    if (!nullToAbsent || metodo != null) {
      map['metodo'] = Variable<String>(metodo);
    }
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || syncId != null) {
      map['sync_id'] = Variable<String>(syncId);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BonoPagosCompanion toCompanion(bool nullToAbsent) {
    return BonoPagosCompanion(
      id: Value(id),
      bonoId: Value(bonoId),
      importe: Value(importe),
      metodo:
          metodo == null && nullToAbsent ? const Value.absent() : Value(metodo),
      fecha: Value(fecha),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      syncId:
          syncId == null && nullToAbsent ? const Value.absent() : Value(syncId),
      deleted: Value(deleted),
    );
  }

  factory BonoPago.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BonoPago(
      id: serializer.fromJson<String>(json['id']),
      bonoId: serializer.fromJson<String>(json['bonoId']),
      importe: serializer.fromJson<double>(json['importe']),
      metodo: serializer.fromJson<String?>(json['metodo']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String?>(json['nota']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      syncId: serializer.fromJson<String?>(json['syncId']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bonoId': serializer.toJson<String>(bonoId),
      'importe': serializer.toJson<double>(importe),
      'metodo': serializer.toJson<String?>(metodo),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String?>(nota),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'syncId': serializer.toJson<String?>(syncId),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  BonoPago copyWith(
          {String? id,
          String? bonoId,
          double? importe,
          Value<String?> metodo = const Value.absent(),
          DateTime? fecha,
          Value<String?> nota = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> syncId = const Value.absent(),
          bool? deleted}) =>
      BonoPago(
        id: id ?? this.id,
        bonoId: bonoId ?? this.bonoId,
        importe: importe ?? this.importe,
        metodo: metodo.present ? metodo.value : this.metodo,
        fecha: fecha ?? this.fecha,
        nota: nota.present ? nota.value : this.nota,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        syncId: syncId.present ? syncId.value : this.syncId,
        deleted: deleted ?? this.deleted,
      );
  BonoPago copyWithCompanion(BonoPagosCompanion data) {
    return BonoPago(
      id: data.id.present ? data.id.value : this.id,
      bonoId: data.bonoId.present ? data.bonoId.value : this.bonoId,
      importe: data.importe.present ? data.importe.value : this.importe,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BonoPago(')
          ..write('id: $id, ')
          ..write('bonoId: $bonoId, ')
          ..write('importe: $importe, ')
          ..write('metodo: $metodo, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bonoId, importe, metodo, fecha, nota,
      createdAt, updatedAt, syncId, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BonoPago &&
          other.id == this.id &&
          other.bonoId == this.bonoId &&
          other.importe == this.importe &&
          other.metodo == this.metodo &&
          other.fecha == this.fecha &&
          other.nota == this.nota &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncId == this.syncId &&
          other.deleted == this.deleted);
}

class BonoPagosCompanion extends UpdateCompanion<BonoPago> {
  final Value<String> id;
  final Value<String> bonoId;
  final Value<double> importe;
  final Value<String?> metodo;
  final Value<DateTime> fecha;
  final Value<String?> nota;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String?> syncId;
  final Value<bool> deleted;
  final Value<int> rowid;
  const BonoPagosCompanion({
    this.id = const Value.absent(),
    this.bonoId = const Value.absent(),
    this.importe = const Value.absent(),
    this.metodo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BonoPagosCompanion.insert({
    required String id,
    required String bonoId,
    required double importe,
    this.metodo = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncId = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        bonoId = Value(bonoId),
        importe = Value(importe);
  static Insertable<BonoPago> custom({
    Expression<String>? id,
    Expression<String>? bonoId,
    Expression<double>? importe,
    Expression<String>? metodo,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? syncId,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bonoId != null) 'bono_id': bonoId,
      if (importe != null) 'importe': importe,
      if (metodo != null) 'metodo': metodo,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncId != null) 'sync_id': syncId,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BonoPagosCompanion copyWith(
      {Value<String>? id,
      Value<String>? bonoId,
      Value<double>? importe,
      Value<String?>? metodo,
      Value<DateTime>? fecha,
      Value<String?>? nota,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<String?>? syncId,
      Value<bool>? deleted,
      Value<int>? rowid}) {
    return BonoPagosCompanion(
      id: id ?? this.id,
      bonoId: bonoId ?? this.bonoId,
      importe: importe ?? this.importe,
      metodo: metodo ?? this.metodo,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncId: syncId ?? this.syncId,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bonoId.present) {
      map['bono_id'] = Variable<String>(bonoId.value);
    }
    if (importe.present) {
      map['importe'] = Variable<double>(importe.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BonoPagosCompanion(')
          ..write('id: $id, ')
          ..write('bonoId: $bonoId, ')
          ..write('importe: $importe, ')
          ..write('metodo: $metodo, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncId: $syncId, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ServiciosTable servicios = $ServiciosTable(this);
  late final $CitasTable citas = $CitasTable(this);
  late final $ExtrasServicioTable extrasServicio = $ExtrasServicioTable(this);
  late final $ExtrasCitaTable extrasCita = $ExtrasCitaTable(this);
  late final $GastosTable gastos = $GastosTable(this);
  late final $BonosTable bonos = $BonosTable(this);
  late final $BonoConsumosTable bonoConsumos = $BonoConsumosTable(this);
  late final $BonoPagosTable bonoPagos = $BonoPagosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clientes,
        servicios,
        citas,
        extrasServicio,
        extrasCita,
        gastos,
        bonos,
        bonoConsumos,
        bonoPagos
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('citas',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('bono_consumos', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  required String id,
  required String nombre,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> notas,
  Value<String?> imagenPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> notas,
  Value<String?> imagenPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CitasTable, List<Cita>> _citasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.citas,
          aliasName: $_aliasNameGenerator(db.clientes.id, db.citas.clienteId));

  $$CitasTableProcessedTableManager get citasRefs {
    final manager = $$CitasTableTableManager($_db, $_db.citas)
        .filter((f) => f.clienteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_citasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  Expression<bool> citasRefs(
      Expression<bool> Function($$CitasTableFilterComposer f) f) {
    final $$CitasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableFilterComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  Expression<T> citasRefs<T extends Object>(
      Expression<T> Function($$CitasTableAnnotationComposer a) f) {
    final $$CitasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableAnnotationComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool citasRefs})> {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String?> imagenPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion(
            id: id,
            nombre: nombre,
            telefono: telefono,
            email: email,
            notas: notas,
            imagenPath: imagenPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String?> imagenPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion.insert(
            id: id,
            nombre: nombre,
            telefono: telefono,
            email: email,
            notas: notas,
            imagenPath: imagenPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ClientesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({citasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (citasRefs) db.citas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (citasRefs)
                    await $_getPrefetchedData<Cliente, $ClientesTable, Cita>(
                        currentTable: table,
                        referencedTable:
                            $$ClientesTableReferences._citasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientesTableReferences(db, table, p0).citasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.clienteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool citasRefs})>;
typedef $$ServiciosTableCreateCompanionBuilder = ServiciosCompanion Function({
  required String id,
  required String nombre,
  required double precio,
  required int duracionMinutos,
  Value<String?> descripcion,
  Value<String?> imagenPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$ServiciosTableUpdateCompanionBuilder = ServiciosCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<double> precio,
  Value<int> duracionMinutos,
  Value<String?> descripcion,
  Value<String?> imagenPath,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$ServiciosTableReferences
    extends BaseReferences<_$AppDatabase, $ServiciosTable, Servicio> {
  $$ServiciosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CitasTable, List<Cita>> _citasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.citas,
          aliasName:
              $_aliasNameGenerator(db.servicios.id, db.citas.servicioId));

  $$CitasTableProcessedTableManager get citasRefs {
    final manager = $$CitasTableTableManager($_db, $_db.citas)
        .filter((f) => f.servicioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_citasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExtrasServicioTable, List<ExtrasServicioData>>
      _extrasServicioRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.extrasServicio,
              aliasName: $_aliasNameGenerator(
                  db.servicios.id, db.extrasServicio.servicioId));

  $$ExtrasServicioTableProcessedTableManager get extrasServicioRefs {
    final manager = $$ExtrasServicioTableTableManager($_db, $_db.extrasServicio)
        .filter((f) => f.servicioId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_extrasServicioRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ServiciosTableFilterComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duracionMinutos => $composableBuilder(
      column: $table.duracionMinutos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  Expression<bool> citasRefs(
      Expression<bool> Function($$CitasTableFilterComposer f) f) {
    final $$CitasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.servicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableFilterComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> extrasServicioRefs(
      Expression<bool> Function($$ExtrasServicioTableFilterComposer f) f) {
    final $$ExtrasServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasServicio,
        getReferencedColumn: (t) => t.servicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasServicioTableFilterComposer(
              $db: $db,
              $table: $db.extrasServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiciosTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duracionMinutos => $composableBuilder(
      column: $table.duracionMinutos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$ServiciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<int> get duracionMinutos => $composableBuilder(
      column: $table.duracionMinutos, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<String> get imagenPath => $composableBuilder(
      column: $table.imagenPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  Expression<T> citasRefs<T extends Object>(
      Expression<T> Function($$CitasTableAnnotationComposer a) f) {
    final $$CitasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.servicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableAnnotationComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> extrasServicioRefs<T extends Object>(
      Expression<T> Function($$ExtrasServicioTableAnnotationComposer a) f) {
    final $$ExtrasServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasServicio,
        getReferencedColumn: (t) => t.servicioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.extrasServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiciosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServiciosTable,
    Servicio,
    $$ServiciosTableFilterComposer,
    $$ServiciosTableOrderingComposer,
    $$ServiciosTableAnnotationComposer,
    $$ServiciosTableCreateCompanionBuilder,
    $$ServiciosTableUpdateCompanionBuilder,
    (Servicio, $$ServiciosTableReferences),
    Servicio,
    PrefetchHooks Function({bool citasRefs, bool extrasServicioRefs})> {
  $$ServiciosTableTableManager(_$AppDatabase db, $ServiciosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<int> duracionMinutos = const Value.absent(),
            Value<String?> descripcion = const Value.absent(),
            Value<String?> imagenPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiciosCompanion(
            id: id,
            nombre: nombre,
            precio: precio,
            duracionMinutos: duracionMinutos,
            descripcion: descripcion,
            imagenPath: imagenPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            required double precio,
            required int duracionMinutos,
            Value<String?> descripcion = const Value.absent(),
            Value<String?> imagenPath = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiciosCompanion.insert(
            id: id,
            nombre: nombre,
            precio: precio,
            duracionMinutos: duracionMinutos,
            descripcion: descripcion,
            imagenPath: imagenPath,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ServiciosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {citasRefs = false, extrasServicioRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (citasRefs) db.citas,
                if (extrasServicioRefs) db.extrasServicio
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (citasRefs)
                    await $_getPrefetchedData<Servicio, $ServiciosTable, Cita>(
                        currentTable: table,
                        referencedTable:
                            $$ServiciosTableReferences._citasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiciosTableReferences(db, table, p0).citasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.servicioId == item.id),
                        typedResults: items),
                  if (extrasServicioRefs)
                    await $_getPrefetchedData<Servicio, $ServiciosTable,
                            ExtrasServicioData>(
                        currentTable: table,
                        referencedTable: $$ServiciosTableReferences
                            ._extrasServicioRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ServiciosTableReferences(db, table, p0)
                                .extrasServicioRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.servicioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ServiciosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServiciosTable,
    Servicio,
    $$ServiciosTableFilterComposer,
    $$ServiciosTableOrderingComposer,
    $$ServiciosTableAnnotationComposer,
    $$ServiciosTableCreateCompanionBuilder,
    $$ServiciosTableUpdateCompanionBuilder,
    (Servicio, $$ServiciosTableReferences),
    Servicio,
    PrefetchHooks Function({bool citasRefs, bool extrasServicioRefs})>;
typedef $$CitasTableCreateCompanionBuilder = CitasCompanion Function({
  required String id,
  required String clienteId,
  required String servicioId,
  required DateTime inicio,
  required DateTime fin,
  required double precio,
  Value<bool> pagada,
  Value<String?> metodoPago,
  Value<String?> notas,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$CitasTableUpdateCompanionBuilder = CitasCompanion Function({
  Value<String> id,
  Value<String> clienteId,
  Value<String> servicioId,
  Value<DateTime> inicio,
  Value<DateTime> fin,
  Value<double> precio,
  Value<bool> pagada,
  Value<String?> metodoPago,
  Value<String?> notas,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$CitasTableReferences
    extends BaseReferences<_$AppDatabase, $CitasTable, Cita> {
  $$CitasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) => db.clientes
      .createAlias($_aliasNameGenerator(db.citas.clienteId, db.clientes.id));

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<String>('cliente_id')!;

    final manager = $$ClientesTableTableManager($_db, $_db.clientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ServiciosTable _servicioIdTable(_$AppDatabase db) => db.servicios
      .createAlias($_aliasNameGenerator(db.citas.servicioId, db.servicios.id));

  $$ServiciosTableProcessedTableManager get servicioId {
    final $_column = $_itemColumn<String>('servicio_id')!;

    final manager = $$ServiciosTableTableManager($_db, $_db.servicios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_servicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ExtrasCitaTable, List<ExtrasCitaData>>
      _extrasCitaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.extrasCita,
          aliasName: $_aliasNameGenerator(db.citas.id, db.extrasCita.citaId));

  $$ExtrasCitaTableProcessedTableManager get extrasCitaRefs {
    final manager = $$ExtrasCitaTableTableManager($_db, $_db.extrasCita)
        .filter((f) => f.citaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_extrasCitaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BonoConsumosTable, List<BonoConsumo>>
      _bonoConsumosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bonoConsumos,
          aliasName: $_aliasNameGenerator(db.citas.id, db.bonoConsumos.citaId));

  $$BonoConsumosTableProcessedTableManager get bonoConsumosRefs {
    final manager = $$BonoConsumosTableTableManager($_db, $_db.bonoConsumos)
        .filter((f) => f.citaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bonoConsumosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CitasTableFilterComposer extends Composer<_$AppDatabase, $CitasTable> {
  $$CitasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get inicio => $composableBuilder(
      column: $table.inicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fin => $composableBuilder(
      column: $table.fin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pagada => $composableBuilder(
      column: $table.pagada, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableFilterComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiciosTableFilterComposer get servicioId {
    final $$ServiciosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableFilterComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> extrasCitaRefs(
      Expression<bool> Function($$ExtrasCitaTableFilterComposer f) f) {
    final $$ExtrasCitaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasCita,
        getReferencedColumn: (t) => t.citaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasCitaTableFilterComposer(
              $db: $db,
              $table: $db.extrasCita,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> bonoConsumosRefs(
      Expression<bool> Function($$BonoConsumosTableFilterComposer f) f) {
    final $$BonoConsumosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoConsumos,
        getReferencedColumn: (t) => t.citaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoConsumosTableFilterComposer(
              $db: $db,
              $table: $db.bonoConsumos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CitasTableOrderingComposer
    extends Composer<_$AppDatabase, $CitasTable> {
  $$CitasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get inicio => $composableBuilder(
      column: $table.inicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fin => $composableBuilder(
      column: $table.fin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pagada => $composableBuilder(
      column: $table.pagada, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableOrderingComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiciosTableOrderingComposer get servicioId {
    final $$ServiciosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableOrderingComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CitasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitasTable> {
  $$CitasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get inicio =>
      $composableBuilder(column: $table.inicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fin =>
      $composableBuilder(column: $table.fin, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<bool> get pagada =>
      $composableBuilder(column: $table.pagada, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableAnnotationComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ServiciosTableAnnotationComposer get servicioId {
    final $$ServiciosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableAnnotationComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> extrasCitaRefs<T extends Object>(
      Expression<T> Function($$ExtrasCitaTableAnnotationComposer a) f) {
    final $$ExtrasCitaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasCita,
        getReferencedColumn: (t) => t.citaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasCitaTableAnnotationComposer(
              $db: $db,
              $table: $db.extrasCita,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> bonoConsumosRefs<T extends Object>(
      Expression<T> Function($$BonoConsumosTableAnnotationComposer a) f) {
    final $$BonoConsumosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoConsumos,
        getReferencedColumn: (t) => t.citaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoConsumosTableAnnotationComposer(
              $db: $db,
              $table: $db.bonoConsumos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CitasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CitasTable,
    Cita,
    $$CitasTableFilterComposer,
    $$CitasTableOrderingComposer,
    $$CitasTableAnnotationComposer,
    $$CitasTableCreateCompanionBuilder,
    $$CitasTableUpdateCompanionBuilder,
    (Cita, $$CitasTableReferences),
    Cita,
    PrefetchHooks Function(
        {bool clienteId,
        bool servicioId,
        bool extrasCitaRefs,
        bool bonoConsumosRefs})> {
  $$CitasTableTableManager(_$AppDatabase db, $CitasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> clienteId = const Value.absent(),
            Value<String> servicioId = const Value.absent(),
            Value<DateTime> inicio = const Value.absent(),
            Value<DateTime> fin = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<bool> pagada = const Value.absent(),
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitasCompanion(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            inicio: inicio,
            fin: fin,
            precio: precio,
            pagada: pagada,
            metodoPago: metodoPago,
            notas: notas,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clienteId,
            required String servicioId,
            required DateTime inicio,
            required DateTime fin,
            required double precio,
            Value<bool> pagada = const Value.absent(),
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitasCompanion.insert(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            inicio: inicio,
            fin: fin,
            precio: precio,
            pagada: pagada,
            metodoPago: metodoPago,
            notas: notas,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CitasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {clienteId = false,
              servicioId = false,
              extrasCitaRefs = false,
              bonoConsumosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (extrasCitaRefs) db.extrasCita,
                if (bonoConsumosRefs) db.bonoConsumos
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clienteId,
                    referencedTable: $$CitasTableReferences._clienteIdTable(db),
                    referencedColumn:
                        $$CitasTableReferences._clienteIdTable(db).id,
                  ) as T;
                }
                if (servicioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.servicioId,
                    referencedTable:
                        $$CitasTableReferences._servicioIdTable(db),
                    referencedColumn:
                        $$CitasTableReferences._servicioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (extrasCitaRefs)
                    await $_getPrefetchedData<Cita, $CitasTable,
                            ExtrasCitaData>(
                        currentTable: table,
                        referencedTable:
                            $$CitasTableReferences._extrasCitaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CitasTableReferences(db, table, p0)
                                .extrasCitaRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.citaId == item.id),
                        typedResults: items),
                  if (bonoConsumosRefs)
                    await $_getPrefetchedData<Cita, $CitasTable, BonoConsumo>(
                        currentTable: table,
                        referencedTable:
                            $$CitasTableReferences._bonoConsumosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CitasTableReferences(db, table, p0)
                                .bonoConsumosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.citaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CitasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CitasTable,
    Cita,
    $$CitasTableFilterComposer,
    $$CitasTableOrderingComposer,
    $$CitasTableAnnotationComposer,
    $$CitasTableCreateCompanionBuilder,
    $$CitasTableUpdateCompanionBuilder,
    (Cita, $$CitasTableReferences),
    Cita,
    PrefetchHooks Function(
        {bool clienteId,
        bool servicioId,
        bool extrasCitaRefs,
        bool bonoConsumosRefs})>;
typedef $$ExtrasServicioTableCreateCompanionBuilder = ExtrasServicioCompanion
    Function({
  required String id,
  required String servicioId,
  required String nombre,
  required double precio,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$ExtrasServicioTableUpdateCompanionBuilder = ExtrasServicioCompanion
    Function({
  Value<String> id,
  Value<String> servicioId,
  Value<String> nombre,
  Value<double> precio,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$ExtrasServicioTableReferences extends BaseReferences<
    _$AppDatabase, $ExtrasServicioTable, ExtrasServicioData> {
  $$ExtrasServicioTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ServiciosTable _servicioIdTable(_$AppDatabase db) =>
      db.servicios.createAlias(
          $_aliasNameGenerator(db.extrasServicio.servicioId, db.servicios.id));

  $$ServiciosTableProcessedTableManager get servicioId {
    final $_column = $_itemColumn<String>('servicio_id')!;

    final manager = $$ServiciosTableTableManager($_db, $_db.servicios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_servicioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ExtrasCitaTable, List<ExtrasCitaData>>
      _extrasCitaRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.extrasCita,
              aliasName: $_aliasNameGenerator(
                  db.extrasServicio.id, db.extrasCita.extraId));

  $$ExtrasCitaTableProcessedTableManager get extrasCitaRefs {
    final manager = $$ExtrasCitaTableTableManager($_db, $_db.extrasCita)
        .filter((f) => f.extraId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_extrasCitaRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExtrasServicioTableFilterComposer
    extends Composer<_$AppDatabase, $ExtrasServicioTable> {
  $$ExtrasServicioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$ServiciosTableFilterComposer get servicioId {
    final $$ServiciosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableFilterComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> extrasCitaRefs(
      Expression<bool> Function($$ExtrasCitaTableFilterComposer f) f) {
    final $$ExtrasCitaTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasCita,
        getReferencedColumn: (t) => t.extraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasCitaTableFilterComposer(
              $db: $db,
              $table: $db.extrasCita,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExtrasServicioTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtrasServicioTable> {
  $$ExtrasServicioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$ServiciosTableOrderingComposer get servicioId {
    final $$ServiciosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableOrderingComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtrasServicioTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtrasServicioTable> {
  $$ExtrasServicioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$ServiciosTableAnnotationComposer get servicioId {
    final $$ServiciosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.servicioId,
        referencedTable: $db.servicios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ServiciosTableAnnotationComposer(
              $db: $db,
              $table: $db.servicios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> extrasCitaRefs<T extends Object>(
      Expression<T> Function($$ExtrasCitaTableAnnotationComposer a) f) {
    final $$ExtrasCitaTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.extrasCita,
        getReferencedColumn: (t) => t.extraId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasCitaTableAnnotationComposer(
              $db: $db,
              $table: $db.extrasCita,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExtrasServicioTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExtrasServicioTable,
    ExtrasServicioData,
    $$ExtrasServicioTableFilterComposer,
    $$ExtrasServicioTableOrderingComposer,
    $$ExtrasServicioTableAnnotationComposer,
    $$ExtrasServicioTableCreateCompanionBuilder,
    $$ExtrasServicioTableUpdateCompanionBuilder,
    (ExtrasServicioData, $$ExtrasServicioTableReferences),
    ExtrasServicioData,
    PrefetchHooks Function({bool servicioId, bool extrasCitaRefs})> {
  $$ExtrasServicioTableTableManager(
      _$AppDatabase db, $ExtrasServicioTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtrasServicioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtrasServicioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtrasServicioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> servicioId = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasServicioCompanion(
            id: id,
            servicioId: servicioId,
            nombre: nombre,
            precio: precio,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String servicioId,
            required String nombre,
            required double precio,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasServicioCompanion.insert(
            id: id,
            servicioId: servicioId,
            nombre: nombre,
            precio: precio,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExtrasServicioTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {servicioId = false, extrasCitaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (extrasCitaRefs) db.extrasCita],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (servicioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.servicioId,
                    referencedTable:
                        $$ExtrasServicioTableReferences._servicioIdTable(db),
                    referencedColumn:
                        $$ExtrasServicioTableReferences._servicioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (extrasCitaRefs)
                    await $_getPrefetchedData<ExtrasServicioData,
                            $ExtrasServicioTable, ExtrasCitaData>(
                        currentTable: table,
                        referencedTable: $$ExtrasServicioTableReferences
                            ._extrasCitaRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExtrasServicioTableReferences(db, table, p0)
                                .extrasCitaRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.extraId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExtrasServicioTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExtrasServicioTable,
    ExtrasServicioData,
    $$ExtrasServicioTableFilterComposer,
    $$ExtrasServicioTableOrderingComposer,
    $$ExtrasServicioTableAnnotationComposer,
    $$ExtrasServicioTableCreateCompanionBuilder,
    $$ExtrasServicioTableUpdateCompanionBuilder,
    (ExtrasServicioData, $$ExtrasServicioTableReferences),
    ExtrasServicioData,
    PrefetchHooks Function({bool servicioId, bool extrasCitaRefs})>;
typedef $$ExtrasCitaTableCreateCompanionBuilder = ExtrasCitaCompanion Function({
  required String citaId,
  required String extraId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$ExtrasCitaTableUpdateCompanionBuilder = ExtrasCitaCompanion Function({
  Value<String> citaId,
  Value<String> extraId,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$ExtrasCitaTableReferences
    extends BaseReferences<_$AppDatabase, $ExtrasCitaTable, ExtrasCitaData> {
  $$ExtrasCitaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CitasTable _citaIdTable(_$AppDatabase db) => db.citas
      .createAlias($_aliasNameGenerator(db.extrasCita.citaId, db.citas.id));

  $$CitasTableProcessedTableManager get citaId {
    final $_column = $_itemColumn<String>('cita_id')!;

    final manager = $$CitasTableTableManager($_db, $_db.citas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_citaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExtrasServicioTable _extraIdTable(_$AppDatabase db) =>
      db.extrasServicio.createAlias(
          $_aliasNameGenerator(db.extrasCita.extraId, db.extrasServicio.id));

  $$ExtrasServicioTableProcessedTableManager get extraId {
    final $_column = $_itemColumn<String>('extra_id')!;

    final manager = $$ExtrasServicioTableTableManager($_db, $_db.extrasServicio)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_extraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExtrasCitaTableFilterComposer
    extends Composer<_$AppDatabase, $ExtrasCitaTable> {
  $$ExtrasCitaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$CitasTableFilterComposer get citaId {
    final $$CitasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableFilterComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExtrasServicioTableFilterComposer get extraId {
    final $$ExtrasServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraId,
        referencedTable: $db.extrasServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasServicioTableFilterComposer(
              $db: $db,
              $table: $db.extrasServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtrasCitaTableOrderingComposer
    extends Composer<_$AppDatabase, $ExtrasCitaTable> {
  $$ExtrasCitaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$CitasTableOrderingComposer get citaId {
    final $$CitasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableOrderingComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExtrasServicioTableOrderingComposer get extraId {
    final $$ExtrasServicioTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraId,
        referencedTable: $db.extrasServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasServicioTableOrderingComposer(
              $db: $db,
              $table: $db.extrasServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtrasCitaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExtrasCitaTable> {
  $$ExtrasCitaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$CitasTableAnnotationComposer get citaId {
    final $$CitasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableAnnotationComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExtrasServicioTableAnnotationComposer get extraId {
    final $$ExtrasServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.extraId,
        referencedTable: $db.extrasServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExtrasServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.extrasServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExtrasCitaTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExtrasCitaTable,
    ExtrasCitaData,
    $$ExtrasCitaTableFilterComposer,
    $$ExtrasCitaTableOrderingComposer,
    $$ExtrasCitaTableAnnotationComposer,
    $$ExtrasCitaTableCreateCompanionBuilder,
    $$ExtrasCitaTableUpdateCompanionBuilder,
    (ExtrasCitaData, $$ExtrasCitaTableReferences),
    ExtrasCitaData,
    PrefetchHooks Function({bool citaId, bool extraId})> {
  $$ExtrasCitaTableTableManager(_$AppDatabase db, $ExtrasCitaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExtrasCitaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExtrasCitaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExtrasCitaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> citaId = const Value.absent(),
            Value<String> extraId = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasCitaCompanion(
            citaId: citaId,
            extraId: extraId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String citaId,
            required String extraId,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasCitaCompanion.insert(
            citaId: citaId,
            extraId: extraId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExtrasCitaTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({citaId = false, extraId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (citaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.citaId,
                    referencedTable:
                        $$ExtrasCitaTableReferences._citaIdTable(db),
                    referencedColumn:
                        $$ExtrasCitaTableReferences._citaIdTable(db).id,
                  ) as T;
                }
                if (extraId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.extraId,
                    referencedTable:
                        $$ExtrasCitaTableReferences._extraIdTable(db),
                    referencedColumn:
                        $$ExtrasCitaTableReferences._extraIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExtrasCitaTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExtrasCitaTable,
    ExtrasCitaData,
    $$ExtrasCitaTableFilterComposer,
    $$ExtrasCitaTableOrderingComposer,
    $$ExtrasCitaTableAnnotationComposer,
    $$ExtrasCitaTableCreateCompanionBuilder,
    $$ExtrasCitaTableUpdateCompanionBuilder,
    (ExtrasCitaData, $$ExtrasCitaTableReferences),
    ExtrasCitaData,
    PrefetchHooks Function({bool citaId, bool extraId})>;
typedef $$GastosTableCreateCompanionBuilder = GastosCompanion Function({
  required String id,
  required String concepto,
  required double precio,
  Value<DateTime> fecha,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$GastosTableUpdateCompanionBuilder = GastosCompanion Function({
  Value<String> id,
  Value<String> concepto,
  Value<double> precio,
  Value<DateTime> fecha,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

class $$GastosTableFilterComposer
    extends Composer<_$AppDatabase, $GastosTable> {
  $$GastosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get concepto => $composableBuilder(
      column: $table.concepto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$GastosTableOrderingComposer
    extends Composer<_$AppDatabase, $GastosTable> {
  $$GastosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get concepto => $composableBuilder(
      column: $table.concepto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precio => $composableBuilder(
      column: $table.precio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$GastosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GastosTable> {
  $$GastosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get concepto =>
      $composableBuilder(column: $table.concepto, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$GastosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GastosTable,
    Gasto,
    $$GastosTableFilterComposer,
    $$GastosTableOrderingComposer,
    $$GastosTableAnnotationComposer,
    $$GastosTableCreateCompanionBuilder,
    $$GastosTableUpdateCompanionBuilder,
    (Gasto, BaseReferences<_$AppDatabase, $GastosTable, Gasto>),
    Gasto,
    PrefetchHooks Function()> {
  $$GastosTableTableManager(_$AppDatabase db, $GastosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GastosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GastosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GastosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> concepto = const Value.absent(),
            Value<double> precio = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GastosCompanion(
            id: id,
            concepto: concepto,
            precio: precio,
            fecha: fecha,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String concepto,
            required double precio,
            Value<DateTime> fecha = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GastosCompanion.insert(
            id: id,
            concepto: concepto,
            precio: precio,
            fecha: fecha,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GastosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GastosTable,
    Gasto,
    $$GastosTableFilterComposer,
    $$GastosTableOrderingComposer,
    $$GastosTableAnnotationComposer,
    $$GastosTableCreateCompanionBuilder,
    $$GastosTableUpdateCompanionBuilder,
    (Gasto, BaseReferences<_$AppDatabase, $GastosTable, Gasto>),
    Gasto,
    PrefetchHooks Function()>;
typedef $$BonosTableCreateCompanionBuilder = BonosCompanion Function({
  required String id,
  required String clienteId,
  required String servicioId,
  Value<String> nombre,
  required int sesionesTotales,
  Value<int> sesionesUsadas,
  Value<double?> precioBono,
  Value<DateTime> compradoEl,
  Value<DateTime?> caducaEl,
  Value<bool> activo,
  Value<DateTime> creadoEl,
  Value<String> reconocimiento,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$BonosTableUpdateCompanionBuilder = BonosCompanion Function({
  Value<String> id,
  Value<String> clienteId,
  Value<String> servicioId,
  Value<String> nombre,
  Value<int> sesionesTotales,
  Value<int> sesionesUsadas,
  Value<double?> precioBono,
  Value<DateTime> compradoEl,
  Value<DateTime?> caducaEl,
  Value<bool> activo,
  Value<DateTime> creadoEl,
  Value<String> reconocimiento,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$BonosTableReferences
    extends BaseReferences<_$AppDatabase, $BonosTable, Bono> {
  $$BonosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BonoConsumosTable, List<BonoConsumo>>
      _bonoConsumosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bonoConsumos,
          aliasName: $_aliasNameGenerator(db.bonos.id, db.bonoConsumos.bonoId));

  $$BonoConsumosTableProcessedTableManager get bonoConsumosRefs {
    final manager = $$BonoConsumosTableTableManager($_db, $_db.bonoConsumos)
        .filter((f) => f.bonoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bonoConsumosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BonoPagosTable, List<BonoPago>>
      _bonoPagosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bonoPagos,
          aliasName: $_aliasNameGenerator(db.bonos.id, db.bonoPagos.bonoId));

  $$BonoPagosTableProcessedTableManager get bonoPagosRefs {
    final manager = $$BonoPagosTableTableManager($_db, $_db.bonoPagos)
        .filter((f) => f.bonoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bonoPagosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BonosTableFilterComposer extends Composer<_$AppDatabase, $BonosTable> {
  $$BonosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get servicioId => $composableBuilder(
      column: $table.servicioId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sesionesTotales => $composableBuilder(
      column: $table.sesionesTotales,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sesionesUsadas => $composableBuilder(
      column: $table.sesionesUsadas,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioBono => $composableBuilder(
      column: $table.precioBono, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get compradoEl => $composableBuilder(
      column: $table.compradoEl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get caducaEl => $composableBuilder(
      column: $table.caducaEl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creadoEl => $composableBuilder(
      column: $table.creadoEl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reconocimiento => $composableBuilder(
      column: $table.reconocimiento,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  Expression<bool> bonoConsumosRefs(
      Expression<bool> Function($$BonoConsumosTableFilterComposer f) f) {
    final $$BonoConsumosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoConsumos,
        getReferencedColumn: (t) => t.bonoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoConsumosTableFilterComposer(
              $db: $db,
              $table: $db.bonoConsumos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> bonoPagosRefs(
      Expression<bool> Function($$BonoPagosTableFilterComposer f) f) {
    final $$BonoPagosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoPagos,
        getReferencedColumn: (t) => t.bonoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoPagosTableFilterComposer(
              $db: $db,
              $table: $db.bonoPagos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BonosTableOrderingComposer
    extends Composer<_$AppDatabase, $BonosTable> {
  $$BonosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clienteId => $composableBuilder(
      column: $table.clienteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get servicioId => $composableBuilder(
      column: $table.servicioId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sesionesTotales => $composableBuilder(
      column: $table.sesionesTotales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sesionesUsadas => $composableBuilder(
      column: $table.sesionesUsadas,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioBono => $composableBuilder(
      column: $table.precioBono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get compradoEl => $composableBuilder(
      column: $table.compradoEl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get caducaEl => $composableBuilder(
      column: $table.caducaEl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creadoEl => $composableBuilder(
      column: $table.creadoEl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reconocimiento => $composableBuilder(
      column: $table.reconocimiento,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$BonosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BonosTable> {
  $$BonosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get servicioId => $composableBuilder(
      column: $table.servicioId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get sesionesTotales => $composableBuilder(
      column: $table.sesionesTotales, builder: (column) => column);

  GeneratedColumn<int> get sesionesUsadas => $composableBuilder(
      column: $table.sesionesUsadas, builder: (column) => column);

  GeneratedColumn<double> get precioBono => $composableBuilder(
      column: $table.precioBono, builder: (column) => column);

  GeneratedColumn<DateTime> get compradoEl => $composableBuilder(
      column: $table.compradoEl, builder: (column) => column);

  GeneratedColumn<DateTime> get caducaEl =>
      $composableBuilder(column: $table.caducaEl, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEl =>
      $composableBuilder(column: $table.creadoEl, builder: (column) => column);

  GeneratedColumn<String> get reconocimiento => $composableBuilder(
      column: $table.reconocimiento, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  Expression<T> bonoConsumosRefs<T extends Object>(
      Expression<T> Function($$BonoConsumosTableAnnotationComposer a) f) {
    final $$BonoConsumosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoConsumos,
        getReferencedColumn: (t) => t.bonoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoConsumosTableAnnotationComposer(
              $db: $db,
              $table: $db.bonoConsumos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> bonoPagosRefs<T extends Object>(
      Expression<T> Function($$BonoPagosTableAnnotationComposer a) f) {
    final $$BonoPagosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bonoPagos,
        getReferencedColumn: (t) => t.bonoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonoPagosTableAnnotationComposer(
              $db: $db,
              $table: $db.bonoPagos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BonosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BonosTable,
    Bono,
    $$BonosTableFilterComposer,
    $$BonosTableOrderingComposer,
    $$BonosTableAnnotationComposer,
    $$BonosTableCreateCompanionBuilder,
    $$BonosTableUpdateCompanionBuilder,
    (Bono, $$BonosTableReferences),
    Bono,
    PrefetchHooks Function({bool bonoConsumosRefs, bool bonoPagosRefs})> {
  $$BonosTableTableManager(_$AppDatabase db, $BonosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BonosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BonosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BonosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> clienteId = const Value.absent(),
            Value<String> servicioId = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> sesionesTotales = const Value.absent(),
            Value<int> sesionesUsadas = const Value.absent(),
            Value<double?> precioBono = const Value.absent(),
            Value<DateTime> compradoEl = const Value.absent(),
            Value<DateTime?> caducaEl = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<DateTime> creadoEl = const Value.absent(),
            Value<String> reconocimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonosCompanion(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            nombre: nombre,
            sesionesTotales: sesionesTotales,
            sesionesUsadas: sesionesUsadas,
            precioBono: precioBono,
            compradoEl: compradoEl,
            caducaEl: caducaEl,
            activo: activo,
            creadoEl: creadoEl,
            reconocimiento: reconocimiento,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clienteId,
            required String servicioId,
            Value<String> nombre = const Value.absent(),
            required int sesionesTotales,
            Value<int> sesionesUsadas = const Value.absent(),
            Value<double?> precioBono = const Value.absent(),
            Value<DateTime> compradoEl = const Value.absent(),
            Value<DateTime?> caducaEl = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<DateTime> creadoEl = const Value.absent(),
            Value<String> reconocimiento = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonosCompanion.insert(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            nombre: nombre,
            sesionesTotales: sesionesTotales,
            sesionesUsadas: sesionesUsadas,
            precioBono: precioBono,
            compradoEl: compradoEl,
            caducaEl: caducaEl,
            activo: activo,
            creadoEl: creadoEl,
            reconocimiento: reconocimiento,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$BonosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {bonoConsumosRefs = false, bonoPagosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (bonoConsumosRefs) db.bonoConsumos,
                if (bonoPagosRefs) db.bonoPagos
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bonoConsumosRefs)
                    await $_getPrefetchedData<Bono, $BonosTable, BonoConsumo>(
                        currentTable: table,
                        referencedTable:
                            $$BonosTableReferences._bonoConsumosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BonosTableReferences(db, table, p0)
                                .bonoConsumosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bonoId == item.id),
                        typedResults: items),
                  if (bonoPagosRefs)
                    await $_getPrefetchedData<Bono, $BonosTable, BonoPago>(
                        currentTable: table,
                        referencedTable:
                            $$BonosTableReferences._bonoPagosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BonosTableReferences(db, table, p0).bonoPagosRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.bonoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BonosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BonosTable,
    Bono,
    $$BonosTableFilterComposer,
    $$BonosTableOrderingComposer,
    $$BonosTableAnnotationComposer,
    $$BonosTableCreateCompanionBuilder,
    $$BonosTableUpdateCompanionBuilder,
    (Bono, $$BonosTableReferences),
    Bono,
    PrefetchHooks Function({bool bonoConsumosRefs, bool bonoPagosRefs})>;
typedef $$BonoConsumosTableCreateCompanionBuilder = BonoConsumosCompanion
    Function({
  required String id,
  required String bonoId,
  Value<String?> citaId,
  Value<DateTime> fecha,
  Value<String?> nota,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$BonoConsumosTableUpdateCompanionBuilder = BonoConsumosCompanion
    Function({
  Value<String> id,
  Value<String> bonoId,
  Value<String?> citaId,
  Value<DateTime> fecha,
  Value<String?> nota,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$BonoConsumosTableReferences
    extends BaseReferences<_$AppDatabase, $BonoConsumosTable, BonoConsumo> {
  $$BonoConsumosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BonosTable _bonoIdTable(_$AppDatabase db) => db.bonos
      .createAlias($_aliasNameGenerator(db.bonoConsumos.bonoId, db.bonos.id));

  $$BonosTableProcessedTableManager get bonoId {
    final $_column = $_itemColumn<String>('bono_id')!;

    final manager = $$BonosTableTableManager($_db, $_db.bonos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bonoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CitasTable _citaIdTable(_$AppDatabase db) => db.citas
      .createAlias($_aliasNameGenerator(db.bonoConsumos.citaId, db.citas.id));

  $$CitasTableProcessedTableManager? get citaId {
    final $_column = $_itemColumn<String>('cita_id');
    if ($_column == null) return null;
    final manager = $$CitasTableTableManager($_db, $_db.citas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_citaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BonoConsumosTableFilterComposer
    extends Composer<_$AppDatabase, $BonoConsumosTable> {
  $$BonoConsumosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$BonosTableFilterComposer get bonoId {
    final $$BonosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableFilterComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CitasTableFilterComposer get citaId {
    final $$CitasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableFilterComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoConsumosTableOrderingComposer
    extends Composer<_$AppDatabase, $BonoConsumosTable> {
  $$BonoConsumosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$BonosTableOrderingComposer get bonoId {
    final $$BonosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableOrderingComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CitasTableOrderingComposer get citaId {
    final $$CitasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableOrderingComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoConsumosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BonoConsumosTable> {
  $$BonoConsumosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$BonosTableAnnotationComposer get bonoId {
    final $$BonosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableAnnotationComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CitasTableAnnotationComposer get citaId {
    final $$CitasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.citaId,
        referencedTable: $db.citas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CitasTableAnnotationComposer(
              $db: $db,
              $table: $db.citas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoConsumosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BonoConsumosTable,
    BonoConsumo,
    $$BonoConsumosTableFilterComposer,
    $$BonoConsumosTableOrderingComposer,
    $$BonoConsumosTableAnnotationComposer,
    $$BonoConsumosTableCreateCompanionBuilder,
    $$BonoConsumosTableUpdateCompanionBuilder,
    (BonoConsumo, $$BonoConsumosTableReferences),
    BonoConsumo,
    PrefetchHooks Function({bool bonoId, bool citaId})> {
  $$BonoConsumosTableTableManager(_$AppDatabase db, $BonoConsumosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BonoConsumosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BonoConsumosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BonoConsumosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bonoId = const Value.absent(),
            Value<String?> citaId = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonoConsumosCompanion(
            id: id,
            bonoId: bonoId,
            citaId: citaId,
            fecha: fecha,
            nota: nota,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bonoId,
            Value<String?> citaId = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonoConsumosCompanion.insert(
            id: id,
            bonoId: bonoId,
            citaId: citaId,
            fecha: fecha,
            nota: nota,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BonoConsumosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bonoId = false, citaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bonoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bonoId,
                    referencedTable:
                        $$BonoConsumosTableReferences._bonoIdTable(db),
                    referencedColumn:
                        $$BonoConsumosTableReferences._bonoIdTable(db).id,
                  ) as T;
                }
                if (citaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.citaId,
                    referencedTable:
                        $$BonoConsumosTableReferences._citaIdTable(db),
                    referencedColumn:
                        $$BonoConsumosTableReferences._citaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BonoConsumosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BonoConsumosTable,
    BonoConsumo,
    $$BonoConsumosTableFilterComposer,
    $$BonoConsumosTableOrderingComposer,
    $$BonoConsumosTableAnnotationComposer,
    $$BonoConsumosTableCreateCompanionBuilder,
    $$BonoConsumosTableUpdateCompanionBuilder,
    (BonoConsumo, $$BonoConsumosTableReferences),
    BonoConsumo,
    PrefetchHooks Function({bool bonoId, bool citaId})>;
typedef $$BonoPagosTableCreateCompanionBuilder = BonoPagosCompanion Function({
  required String id,
  required String bonoId,
  required double importe,
  Value<String?> metodo,
  Value<DateTime> fecha,
  Value<String?> nota,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});
typedef $$BonoPagosTableUpdateCompanionBuilder = BonoPagosCompanion Function({
  Value<String> id,
  Value<String> bonoId,
  Value<double> importe,
  Value<String?> metodo,
  Value<DateTime> fecha,
  Value<String?> nota,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<String?> syncId,
  Value<bool> deleted,
  Value<int> rowid,
});

final class $$BonoPagosTableReferences
    extends BaseReferences<_$AppDatabase, $BonoPagosTable, BonoPago> {
  $$BonoPagosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BonosTable _bonoIdTable(_$AppDatabase db) => db.bonos
      .createAlias($_aliasNameGenerator(db.bonoPagos.bonoId, db.bonos.id));

  $$BonosTableProcessedTableManager get bonoId {
    final $_column = $_itemColumn<String>('bono_id')!;

    final manager = $$BonosTableTableManager($_db, $_db.bonos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bonoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BonoPagosTableFilterComposer
    extends Composer<_$AppDatabase, $BonoPagosTable> {
  $$BonoPagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get importe => $composableBuilder(
      column: $table.importe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodo => $composableBuilder(
      column: $table.metodo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  $$BonosTableFilterComposer get bonoId {
    final $$BonosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableFilterComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoPagosTableOrderingComposer
    extends Composer<_$AppDatabase, $BonoPagosTable> {
  $$BonoPagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get importe => $composableBuilder(
      column: $table.importe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodo => $composableBuilder(
      column: $table.metodo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncId => $composableBuilder(
      column: $table.syncId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  $$BonosTableOrderingComposer get bonoId {
    final $$BonosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableOrderingComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoPagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BonoPagosTable> {
  $$BonoPagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get importe =>
      $composableBuilder(column: $table.importe, builder: (column) => column);

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$BonosTableAnnotationComposer get bonoId {
    final $$BonosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bonoId,
        referencedTable: $db.bonos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BonosTableAnnotationComposer(
              $db: $db,
              $table: $db.bonos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BonoPagosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BonoPagosTable,
    BonoPago,
    $$BonoPagosTableFilterComposer,
    $$BonoPagosTableOrderingComposer,
    $$BonoPagosTableAnnotationComposer,
    $$BonoPagosTableCreateCompanionBuilder,
    $$BonoPagosTableUpdateCompanionBuilder,
    (BonoPago, $$BonoPagosTableReferences),
    BonoPago,
    PrefetchHooks Function({bool bonoId})> {
  $$BonoPagosTableTableManager(_$AppDatabase db, $BonoPagosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BonoPagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BonoPagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BonoPagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> bonoId = const Value.absent(),
            Value<double> importe = const Value.absent(),
            Value<String?> metodo = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonoPagosCompanion(
            id: id,
            bonoId: bonoId,
            importe: importe,
            metodo: metodo,
            fecha: fecha,
            nota: nota,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String bonoId,
            required double importe,
            Value<String?> metodo = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> syncId = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BonoPagosCompanion.insert(
            id: id,
            bonoId: bonoId,
            importe: importe,
            metodo: metodo,
            fecha: fecha,
            nota: nota,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncId: syncId,
            deleted: deleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BonoPagosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bonoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bonoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bonoId,
                    referencedTable:
                        $$BonoPagosTableReferences._bonoIdTable(db),
                    referencedColumn:
                        $$BonoPagosTableReferences._bonoIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BonoPagosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BonoPagosTable,
    BonoPago,
    $$BonoPagosTableFilterComposer,
    $$BonoPagosTableOrderingComposer,
    $$BonoPagosTableAnnotationComposer,
    $$BonoPagosTableCreateCompanionBuilder,
    $$BonoPagosTableUpdateCompanionBuilder,
    (BonoPago, $$BonoPagosTableReferences),
    BonoPago,
    PrefetchHooks Function({bool bonoId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db, _db.servicios);
  $$CitasTableTableManager get citas =>
      $$CitasTableTableManager(_db, _db.citas);
  $$ExtrasServicioTableTableManager get extrasServicio =>
      $$ExtrasServicioTableTableManager(_db, _db.extrasServicio);
  $$ExtrasCitaTableTableManager get extrasCita =>
      $$ExtrasCitaTableTableManager(_db, _db.extrasCita);
  $$GastosTableTableManager get gastos =>
      $$GastosTableTableManager(_db, _db.gastos);
  $$BonosTableTableManager get bonos =>
      $$BonosTableTableManager(_db, _db.bonos);
  $$BonoConsumosTableTableManager get bonoConsumos =>
      $$BonoConsumosTableTableManager(_db, _db.bonoConsumos);
  $$BonoPagosTableTableManager get bonoPagos =>
      $$BonoPagosTableTableManager(_db, _db.bonoPagos);
}
