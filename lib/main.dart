import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_root.dart';
import 'services/notification_service.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService.instance.init();

      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('[FLUTTER ERROR] ${details.exception}');
        debugPrint('[FLUTTER ERROR STACK] ${details.stack}');
      };

      runApp(
        const ProviderScope(
          child: AppRoot(),
        ),
      );
    },
    (error, stack) {
      debugPrint('[ZONE ERROR] $error');
      debugPrint('[ZONE STACK] $stack');
    },
  );
}
