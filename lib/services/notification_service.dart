import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _chanCitas   = 'centerly_citas';
  static const _chanAlerts  = 'centerly_alertas';
  static const _idImpagos   = 9001;
  static const _idInactivos = 9002;

  Future<void> init() async {
    if (_ready) return;
    // flutter_local_notifications no soporta Windows ni Web
    if (Platform.isWindows) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      final ap = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await ap?.createNotificationChannel(const AndroidNotificationChannel(
        _chanCitas,
        'Recordatorios de citas',
        description: 'Aviso antes de cada cita programada',
        importance: Importance.high,
      ));
      await ap?.createNotificationChannel(const AndroidNotificationChannel(
        _chanAlerts,
        'Alertas del negocio',
        description: 'Alertas de impagos y clientes inactivos',
        importance: Importance.defaultImportance,
      ));
    }

    _ready = true;
    await _requestPermissionOnce();
  }

  Future<void> _requestPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('notif_permission_asked') == true) return;
    await prefs.setBool('notif_permission_asked', true);

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// Determina el modo de alarma óptimo según los permisos disponibles.
  Future<AndroidScheduleMode> _bestScheduleMode() async {
    if (!Platform.isAndroid) return AndroidScheduleMode.inexactAllowWhileIdle;
    final ap = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final canExact = await ap?.canScheduleExactNotifications() ?? false;
    return canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  // Convierte un UUID de cita en un ID entero único para la notificación
  int _citaId(String citaId) => citaId.hashCode.abs() % 100000;

  /// Programa un recordatorio para [citaId].
  ///
  /// - Si la cita es > 1 hora: programa la notificación 1 h antes.
  /// - Si la cita es < 1 hora pero aún futura: notificación inmediata
  ///   ("cita próxima") — cubre también el caso de pruebas rápidas.
  /// - Si la cita ya empezó: no hace nada.
  Future<void> scheduleCitaReminder({
    required String citaId,
    required String clienteNombre,
    required String servicioNombre,
    required DateTime inicio,
  }) async {
    if (!_ready) return;

    final now = DateTime.now();
    if (!inicio.isAfter(now)) return; // cita ya pasada

    final hora =
        '${inicio.hour.toString().padLeft(2, '0')}:${inicio.minute.toString().padLeft(2, '0')}';

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _chanCitas,
        'Recordatorios de citas',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(presentSound: true),
    );

    final reminderAt = inicio.subtract(const Duration(hours: 1));

    try {
      if (reminderAt.isAfter(now)) {
        // Cita a más de 1 hora: programar alarma
        final mode = await _bestScheduleMode();
        await _plugin.zonedSchedule(
          _citaId(citaId),
          'Cita en 1 hora',
          '$clienteNombre – $servicioNombre a las $hora',
          tz.TZDateTime.from(reminderAt, tz.local),
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        // Cita en menos de 1 hora: notificación inmediata
        await _plugin.show(
          _citaId(citaId),
          'Cita próxima',
          '$clienteNombre – $servicioNombre a las $hora',
          details,
        );
      }
    } catch (_) {
      // Si los permisos de alarma exacta no están concedidos, reintentar con inexacta
      try {
        await _plugin.zonedSchedule(
          _citaId(citaId),
          'Cita en 1 hora',
          '$clienteNombre – $servicioNombre a las $hora',
          tz.TZDateTime.from(reminderAt.isAfter(now) ? reminderAt : now.add(const Duration(seconds: 5)), tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (_) {
        // Silenciar si tampoco funciona la inexacta
      }
    }
  }

  /// Cancela el recordatorio de una cita (al editarla o eliminarla).
  Future<void> cancelCitaReminder(String citaId) async {
    if (!_ready) return;
    await _plugin.cancel(_citaId(citaId));
  }

  /// Muestra una notificación con el resumen de impagos.
  Future<void> showImpagosNotif(int count, double total, String simbolo) async {
    if (!_ready || count <= 0) return;
    final totalStr = total.toStringAsFixed(2);
    final body = count == 1
        ? '1 cita sin cobrar · $totalStr $simbolo'
        : '$count citas sin cobrar · $totalStr $simbolo';

    await _plugin.show(
      _idImpagos,
      'Pagos pendientes',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _chanAlerts,
          'Alertas del negocio',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(presentSound: false),
      ),
    );
  }

  /// Muestra una notificación con el número de clientes inactivos.
  Future<void> showClientesInactivosNotif(int count, int dias) async {
    if (!_ready || count <= 0) return;
    final body = count == 1
        ? '1 cliente lleva más de $dias días sin visitarte'
        : '$count clientes llevan más de $dias días sin visitarte';

    await _plugin.show(
      _idInactivos,
      'Clientes sin visita reciente',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _chanAlerts,
          'Alertas del negocio',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(presentSound: false),
      ),
    );
  }

  /// Devuelve true si esta notificación no se ha mostrado hoy todavía.
  Future<bool> shouldShowToday(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (prefs.getString(key) == today) return false;
    await prefs.setString(key, today);
    return true;
  }
}
