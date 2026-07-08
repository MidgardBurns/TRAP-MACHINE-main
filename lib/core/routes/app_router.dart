import 'package:flutter/material.dart';

import '../layout/trap_app_shell.dart';
import 'app_route.dart';

abstract final class AppRouter {
  static const initialRoute = '/mapa';

  static Map<String, WidgetBuilder> get routes => {
    '/': (_) => const TrapAppShell(initialRoute: AppRoute.map),
    for (final route in AppRoute.values)
      route.path: (_) => TrapAppShell(initialRoute: route),
  };
}
