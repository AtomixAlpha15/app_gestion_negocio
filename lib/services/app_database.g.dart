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
        notas
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
  const Cita(
      {required this.id,
      required this.clienteId,
      required this.servicioId,
      required this.inicio,
      required this.fin,
      required this.precio,
      required this.pagada,
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
    map['pagada'] = Variable<bool>(pagada);
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
      pagada: Value(pagada),
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
      pagada: serializer.fromJson<bool>(json['pagada']),
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
      'pagada': serializer.toJson<bool>(pagada),
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
          bool? pagada,
          Value<String?> metodoPago = const Value.absent(),
          Value<String?> notas = const Value.absent()}) =>
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
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clienteId, servicioId, inicio, fin,
      precio, pagada, metodoPago, notas);
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
          other.notas == this.notas);
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
  @override
  List<GeneratedColumn> get $columns => [id, servicioId, nombre, precio];
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
  const ExtrasServicioData(
      {required this.id,
      required this.servicioId,
      required this.nombre,
      required this.precio});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['servicio_id'] = Variable<String>(servicioId);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    return map;
  }

  ExtrasServicioCompanion toCompanion(bool nullToAbsent) {
    return ExtrasServicioCompanion(
      id: Value(id),
      servicioId: Value(servicioId),
      nombre: Value(nombre),
      precio: Value(precio),
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
    };
  }

  ExtrasServicioData copyWith(
          {String? id, String? servicioId, String? nombre, double? precio}) =>
      ExtrasServicioData(
        id: id ?? this.id,
        servicioId: servicioId ?? this.servicioId,
        nombre: nombre ?? this.nombre,
        precio: precio ?? this.precio,
      );
  ExtrasServicioData copyWithCompanion(ExtrasServicioCompanion data) {
    return ExtrasServicioData(
      id: data.id.present ? data.id.value : this.id,
      servicioId:
          data.servicioId.present ? data.servicioId.value : this.servicioId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasServicioData(')
          ..write('id: $id, ')
          ..write('servicioId: $servicioId, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, servicioId, nombre, precio);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtrasServicioData &&
          other.id == this.id &&
          other.servicioId == this.servicioId &&
          other.nombre == this.nombre &&
          other.precio == this.precio);
}

class ExtrasServicioCompanion extends UpdateCompanion<ExtrasServicioData> {
  final Value<String> id;
  final Value<String> servicioId;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<int> rowid;
  const ExtrasServicioCompanion({
    this.id = const Value.absent(),
    this.servicioId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtrasServicioCompanion.insert({
    required String id,
    required String servicioId,
    required String nombre,
    required double precio,
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (servicioId != null) 'servicio_id': servicioId,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtrasServicioCompanion copyWith(
      {Value<String>? id,
      Value<String>? servicioId,
      Value<String>? nombre,
      Value<double>? precio,
      Value<int>? rowid}) {
    return ExtrasServicioCompanion(
      id: id ?? this.id,
      servicioId: servicioId ?? this.servicioId,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
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
  @override
  List<GeneratedColumn> get $columns => [citaId, extraId];
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
  const ExtrasCitaData({required this.citaId, required this.extraId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cita_id'] = Variable<String>(citaId);
    map['extra_id'] = Variable<String>(extraId);
    return map;
  }

  ExtrasCitaCompanion toCompanion(bool nullToAbsent) {
    return ExtrasCitaCompanion(
      citaId: Value(citaId),
      extraId: Value(extraId),
    );
  }

  factory ExtrasCitaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExtrasCitaData(
      citaId: serializer.fromJson<String>(json['citaId']),
      extraId: serializer.fromJson<String>(json['extraId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'citaId': serializer.toJson<String>(citaId),
      'extraId': serializer.toJson<String>(extraId),
    };
  }

  ExtrasCitaData copyWith({String? citaId, String? extraId}) => ExtrasCitaData(
        citaId: citaId ?? this.citaId,
        extraId: extraId ?? this.extraId,
      );
  ExtrasCitaData copyWithCompanion(ExtrasCitaCompanion data) {
    return ExtrasCitaData(
      citaId: data.citaId.present ? data.citaId.value : this.citaId,
      extraId: data.extraId.present ? data.extraId.value : this.extraId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExtrasCitaData(')
          ..write('citaId: $citaId, ')
          ..write('extraId: $extraId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(citaId, extraId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExtrasCitaData &&
          other.citaId == this.citaId &&
          other.extraId == this.extraId);
}

class ExtrasCitaCompanion extends UpdateCompanion<ExtrasCitaData> {
  final Value<String> citaId;
  final Value<String> extraId;
  final Value<int> rowid;
  const ExtrasCitaCompanion({
    this.citaId = const Value.absent(),
    this.extraId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExtrasCitaCompanion.insert({
    required String citaId,
    required String extraId,
    this.rowid = const Value.absent(),
  })  : citaId = Value(citaId),
        extraId = Value(extraId);
  static Insertable<ExtrasCitaData> custom({
    Expression<String>? citaId,
    Expression<String>? extraId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (citaId != null) 'cita_id': citaId,
      if (extraId != null) 'extra_id': extraId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExtrasCitaCompanion copyWith(
      {Value<String>? citaId, Value<String>? extraId, Value<int>? rowid}) {
    return ExtrasCitaCompanion(
      citaId: citaId ?? this.citaId,
      extraId: extraId ?? this.extraId,
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
  static const VerificationMeta _mesMeta = const VerificationMeta('mes');
  @override
  late final GeneratedColumn<int> mes = GeneratedColumn<int>(
      'mes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
      'anio', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, concepto, precio, mes, anio];
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
    if (data.containsKey('mes')) {
      context.handle(
          _mesMeta, mes.isAcceptableOrUnknown(data['mes']!, _mesMeta));
    } else if (isInserting) {
      context.missing(_mesMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
          _anioMeta, anio.isAcceptableOrUnknown(data['anio']!, _anioMeta));
    } else if (isInserting) {
      context.missing(_anioMeta);
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
      mes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mes'])!,
      anio: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio'])!,
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
  final int mes;
  final int anio;
  const Gasto(
      {required this.id,
      required this.concepto,
      required this.precio,
      required this.mes,
      required this.anio});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['concepto'] = Variable<String>(concepto);
    map['precio'] = Variable<double>(precio);
    map['mes'] = Variable<int>(mes);
    map['anio'] = Variable<int>(anio);
    return map;
  }

  GastosCompanion toCompanion(bool nullToAbsent) {
    return GastosCompanion(
      id: Value(id),
      concepto: Value(concepto),
      precio: Value(precio),
      mes: Value(mes),
      anio: Value(anio),
    );
  }

  factory Gasto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gasto(
      id: serializer.fromJson<String>(json['id']),
      concepto: serializer.fromJson<String>(json['concepto']),
      precio: serializer.fromJson<double>(json['precio']),
      mes: serializer.fromJson<int>(json['mes']),
      anio: serializer.fromJson<int>(json['anio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'concepto': serializer.toJson<String>(concepto),
      'precio': serializer.toJson<double>(precio),
      'mes': serializer.toJson<int>(mes),
      'anio': serializer.toJson<int>(anio),
    };
  }

  Gasto copyWith(
          {String? id,
          String? concepto,
          double? precio,
          int? mes,
          int? anio}) =>
      Gasto(
        id: id ?? this.id,
        concepto: concepto ?? this.concepto,
        precio: precio ?? this.precio,
        mes: mes ?? this.mes,
        anio: anio ?? this.anio,
      );
  Gasto copyWithCompanion(GastosCompanion data) {
    return Gasto(
      id: data.id.present ? data.id.value : this.id,
      concepto: data.concepto.present ? data.concepto.value : this.concepto,
      precio: data.precio.present ? data.precio.value : this.precio,
      mes: data.mes.present ? data.mes.value : this.mes,
      anio: data.anio.present ? data.anio.value : this.anio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gasto(')
          ..write('id: $id, ')
          ..write('concepto: $concepto, ')
          ..write('precio: $precio, ')
          ..write('mes: $mes, ')
          ..write('anio: $anio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concepto, precio, mes, anio);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gasto &&
          other.id == this.id &&
          other.concepto == this.concepto &&
          other.precio == this.precio &&
          other.mes == this.mes &&
          other.anio == this.anio);
}

class GastosCompanion extends UpdateCompanion<Gasto> {
  final Value<String> id;
  final Value<String> concepto;
  final Value<double> precio;
  final Value<int> mes;
  final Value<int> anio;
  final Value<int> rowid;
  const GastosCompanion({
    this.id = const Value.absent(),
    this.concepto = const Value.absent(),
    this.precio = const Value.absent(),
    this.mes = const Value.absent(),
    this.anio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GastosCompanion.insert({
    required String id,
    required String concepto,
    required double precio,
    required int mes,
    required int anio,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        concepto = Value(concepto),
        precio = Value(precio),
        mes = Value(mes),
        anio = Value(anio);
  static Insertable<Gasto> custom({
    Expression<String>? id,
    Expression<String>? concepto,
    Expression<double>? precio,
    Expression<int>? mes,
    Expression<int>? anio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concepto != null) 'concepto': concepto,
      if (precio != null) 'precio': precio,
      if (mes != null) 'mes': mes,
      if (anio != null) 'anio': anio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GastosCompanion copyWith(
      {Value<String>? id,
      Value<String>? concepto,
      Value<double>? precio,
      Value<int>? mes,
      Value<int>? anio,
      Value<int>? rowid}) {
    return GastosCompanion(
      id: id ?? this.id,
      concepto: concepto ?? this.concepto,
      precio: precio ?? this.precio,
      mes: mes ?? this.mes,
      anio: anio ?? this.anio,
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
    if (mes.present) {
      map['mes'] = Variable<int>(mes.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
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
          ..write('mes: $mes, ')
          ..write('anio: $anio, ')
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
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [clientes, servicios, citas, extrasServicio, extrasCita, gastos];
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
        {bool clienteId, bool servicioId, bool extrasCitaRefs})> {
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
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CitasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {clienteId = false, servicioId = false, extrasCitaRefs = false}) {
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
        {bool clienteId, bool servicioId, bool extrasCitaRefs})>;
typedef $$ExtrasServicioTableCreateCompanionBuilder = ExtrasServicioCompanion
    Function({
  required String id,
  required String servicioId,
  required String nombre,
  required double precio,
  Value<int> rowid,
});
typedef $$ExtrasServicioTableUpdateCompanionBuilder = ExtrasServicioCompanion
    Function({
  Value<String> id,
  Value<String> servicioId,
  Value<String> nombre,
  Value<double> precio,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasServicioCompanion(
            id: id,
            servicioId: servicioId,
            nombre: nombre,
            precio: precio,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String servicioId,
            required String nombre,
            required double precio,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasServicioCompanion.insert(
            id: id,
            servicioId: servicioId,
            nombre: nombre,
            precio: precio,
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
  Value<int> rowid,
});
typedef $$ExtrasCitaTableUpdateCompanionBuilder = ExtrasCitaCompanion Function({
  Value<String> citaId,
  Value<String> extraId,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasCitaCompanion(
            citaId: citaId,
            extraId: extraId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String citaId,
            required String extraId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExtrasCitaCompanion.insert(
            citaId: citaId,
            extraId: extraId,
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
  required int mes,
  required int anio,
  Value<int> rowid,
});
typedef $$GastosTableUpdateCompanionBuilder = GastosCompanion Function({
  Value<String> id,
  Value<String> concepto,
  Value<double> precio,
  Value<int> mes,
  Value<int> anio,
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

  ColumnFilters<int> get mes => $composableBuilder(
      column: $table.mes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get mes => $composableBuilder(
      column: $table.mes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get mes =>
      $composableBuilder(column: $table.mes, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);
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
            Value<int> mes = const Value.absent(),
            Value<int> anio = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GastosCompanion(
            id: id,
            concepto: concepto,
            precio: precio,
            mes: mes,
            anio: anio,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String concepto,
            required double precio,
            required int mes,
            required int anio,
            Value<int> rowid = const Value.absent(),
          }) =>
              GastosCompanion.insert(
            id: id,
            concepto: concepto,
            precio: precio,
            mes: mes,
            anio: anio,
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
}
