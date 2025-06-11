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
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, telefono, email, notas, imagenPath];
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
  const Cliente(
      {required this.id,
      required this.nombre,
      this.telefono,
      this.email,
      this.notas,
      this.imagenPath});
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
    };
  }

  Cliente copyWith(
          {String? id,
          String? nombre,
          Value<String?> telefono = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          Value<String?> imagenPath = const Value.absent()}) =>
      Cliente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        telefono: telefono.present ? telefono.value : this.telefono,
        email: email.present ? email.value : this.email,
        notas: notas.present ? notas.value : this.notas,
        imagenPath: imagenPath.present ? imagenPath.value : this.imagenPath,
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
          ..write('imagenPath: $imagenPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, telefono, email, notas, imagenPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.notas == this.notas &&
          other.imagenPath == this.imagenPath);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> notas;
  final Value<String?> imagenPath;
  final Value<int> rowid;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientesCompanion.insert({
    required String id,
    required String nombre,
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.notas = const Value.absent(),
    this.imagenPath = const Value.absent(),
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (notas != null) 'notas': notas,
      if (imagenPath != null) 'imagen_path': imagenPath,
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
      Value<int>? rowid}) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      notas: notas ?? this.notas,
      imagenPath: imagenPath ?? this.imagenPath,
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, precio, duracionMinutos, descripcion];
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
  const Servicio(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.duracionMinutos,
      this.descripcion});
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
    };
  }

  Servicio copyWith(
          {String? id,
          String? nombre,
          double? precio,
          int? duracionMinutos,
          Value<String?> descripcion = const Value.absent()}) =>
      Servicio(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        precio: precio ?? this.precio,
        duracionMinutos: duracionMinutos ?? this.duracionMinutos,
        descripcion: descripcion.present ? descripcion.value : this.descripcion,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servicio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('duracionMinutos: $duracionMinutos, ')
          ..write('descripcion: $descripcion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, precio, duracionMinutos, descripcion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servicio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.duracionMinutos == this.duracionMinutos &&
          other.descripcion == this.descripcion);
}

class ServiciosCompanion extends UpdateCompanion<Servicio> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<int> duracionMinutos;
  final Value<String?> descripcion;
  final Value<int> rowid;
  const ServiciosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.duracionMinutos = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiciosCompanion.insert({
    required String id,
    required String nombre,
    required double precio,
    required int duracionMinutos,
    this.descripcion = const Value.absent(),
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (duracionMinutos != null) 'duracion_minutos': duracionMinutos,
      if (descripcion != null) 'descripcion': descripcion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiciosCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<double>? precio,
      Value<int>? duracionMinutos,
      Value<String?>? descripcion,
      Value<int>? rowid}) {
    return ServiciosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      descripcion: descripcion ?? this.descripcion,
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, clienteId, servicioId, inicio, fin, precio, metodoPago, notas];
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
      metodoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo_pago']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
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
  final String? metodoPago;
  final String? notas;
  const Cita(
      {required this.id,
      required this.clienteId,
      required this.servicioId,
      required this.inicio,
      required this.fin,
      required this.precio,
      this.metodoPago,
      this.notas});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cliente_id'] = Variable<String>(clienteId);
    map['servicio_id'] = Variable<String>(servicioId);
    map['inicio'] = Variable<DateTime>(inicio);
    map['fin'] = Variable<DateTime>(fin);
    map['precio'] = Variable<double>(precio);
    if (!nullToAbsent || metodoPago != null) {
      map['metodo_pago'] = Variable<String>(metodoPago);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
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
      metodoPago: metodoPago == null && nullToAbsent
          ? const Value.absent()
          : Value(metodoPago),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
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
      metodoPago: serializer.fromJson<String?>(json['metodoPago']),
      notas: serializer.fromJson<String?>(json['notas']),
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
      'metodoPago': serializer.toJson<String?>(metodoPago),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  Cita copyWith(
          {String? id,
          String? clienteId,
          String? servicioId,
          DateTime? inicio,
          DateTime? fin,
          double? precio,
          Value<String?> metodoPago = const Value.absent(),
          Value<String?> notas = const Value.absent()}) =>
      Cita(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        servicioId: servicioId ?? this.servicioId,
        inicio: inicio ?? this.inicio,
        fin: fin ?? this.fin,
        precio: precio ?? this.precio,
        metodoPago: metodoPago.present ? metodoPago.value : this.metodoPago,
        notas: notas.present ? notas.value : this.notas,
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
      metodoPago:
          data.metodoPago.present ? data.metodoPago.value : this.metodoPago,
      notas: data.notas.present ? data.notas.value : this.notas,
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
          ..write('metodoPago: $metodoPago, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, clienteId, servicioId, inicio, fin, precio, metodoPago, notas);
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
          other.metodoPago == this.metodoPago &&
          other.notas == this.notas);
}

class CitasCompanion extends UpdateCompanion<Cita> {
  final Value<String> id;
  final Value<String> clienteId;
  final Value<String> servicioId;
  final Value<DateTime> inicio;
  final Value<DateTime> fin;
  final Value<double> precio;
  final Value<String?> metodoPago;
  final Value<String?> notas;
  final Value<int> rowid;
  const CitasCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.inicio = const Value.absent(),
    this.fin = const Value.absent(),
    this.precio = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.notas = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitasCompanion.insert({
    required String id,
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    this.metodoPago = const Value.absent(),
    this.notas = const Value.absent(),
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
    Expression<String>? metodoPago,
    Expression<String>? notas,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (servicioId != null) 'servicio_id': servicioId,
      if (inicio != null) 'inicio': inicio,
      if (fin != null) 'fin': fin,
      if (precio != null) 'precio': precio,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (notas != null) 'notas': notas,
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
      Value<String?>? metodoPago,
      Value<String?>? notas,
      Value<int>? rowid}) {
    return CitasCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      servicioId: servicioId ?? this.servicioId,
      inicio: inicio ?? this.inicio,
      fin: fin ?? this.fin,
      precio: precio ?? this.precio,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
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
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
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
          ..write('metodoPago: $metodoPago, ')
          ..write('notas: $notas, ')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [clientes, servicios, citas];
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  required String id,
  required String nombre,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> notas,
  Value<String?> imagenPath,
  Value<int> rowid,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> notas,
  Value<String?> imagenPath,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion(
            id: id,
            nombre: nombre,
            telefono: telefono,
            email: email,
            notas: notas,
            imagenPath: imagenPath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<String?> imagenPath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientesCompanion.insert(
            id: id,
            nombre: nombre,
            telefono: telefono,
            email: email,
            notas: notas,
            imagenPath: imagenPath,
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
  Value<int> rowid,
});
typedef $$ServiciosTableUpdateCompanionBuilder = ServiciosCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<double> precio,
  Value<int> duracionMinutos,
  Value<String?> descripcion,
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
    PrefetchHooks Function({bool citasRefs})> {
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
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiciosCompanion(
            id: id,
            nombre: nombre,
            precio: precio,
            duracionMinutos: duracionMinutos,
            descripcion: descripcion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            required double precio,
            required int duracionMinutos,
            Value<String?> descripcion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiciosCompanion.insert(
            id: id,
            nombre: nombre,
            precio: precio,
            duracionMinutos: duracionMinutos,
            descripcion: descripcion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ServiciosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({citasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (citasRefs) db.citas],
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
    PrefetchHooks Function({bool citasRefs})>;
typedef $$CitasTableCreateCompanionBuilder = CitasCompanion Function({
  required String id,
  required String clienteId,
  required String servicioId,
  required DateTime inicio,
  required DateTime fin,
  required double precio,
  Value<String?> metodoPago,
  Value<String?> notas,
  Value<int> rowid,
});
typedef $$CitasTableUpdateCompanionBuilder = CitasCompanion Function({
  Value<String> id,
  Value<String> clienteId,
  Value<String> servicioId,
  Value<DateTime> inicio,
  Value<DateTime> fin,
  Value<double> precio,
  Value<String?> metodoPago,
  Value<String?> notas,
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

  ColumnFilters<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

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
    PrefetchHooks Function({bool clienteId, bool servicioId})> {
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
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitasCompanion(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            inicio: inicio,
            fin: fin,
            precio: precio,
            metodoPago: metodoPago,
            notas: notas,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clienteId,
            required String servicioId,
            required DateTime inicio,
            required DateTime fin,
            required double precio,
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitasCompanion.insert(
            id: id,
            clienteId: clienteId,
            servicioId: servicioId,
            inicio: inicio,
            fin: fin,
            precio: precio,
            metodoPago: metodoPago,
            notas: notas,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CitasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({clienteId = false, servicioId = false}) {
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
                return [];
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
    PrefetchHooks Function({bool clienteId, bool servicioId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db, _db.servicios);
  $$CitasTableTableManager get citas =>
      $$CitasTableTableManager(_db, _db.citas);
}
