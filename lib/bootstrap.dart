import 'dart:async';

import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
    runApp(const App());
  }, (error, stackTrace) {
    debugPrint('Uncaught error: $error');
    debugPrintStack(stackTrace: stackTrace);
  });
}
