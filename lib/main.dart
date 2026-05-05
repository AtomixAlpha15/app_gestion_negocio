import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_root.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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
