import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';

void main() {
  runApp(const TrapMachineApp());
}

class TrapMachineApp extends StatelessWidget {
  const TrapMachineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Trap Machine',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD7FF00),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
        ),
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
      ),
    );
  }
}
