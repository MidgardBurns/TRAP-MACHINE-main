import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/feed/presentation/feed_page.dart';
import '../../features/inbox/presentation/inbox_page.dart';
import '../../features/mapa/presentation/mapa_page.dart';
import '../../features/perfil/presentation/profile_page.dart';
import '../routes/app_route.dart';
import 'trap_bottom_menu.dart';

final selectedRouteProvider = NotifierProvider<SelectedRouteNotifier, AppRoute>(
  SelectedRouteNotifier.new,
);

class SelectedRouteNotifier extends Notifier<AppRoute> {
  @override
  AppRoute build() => AppRoute.map;

  void select(AppRoute route) {
    state = route;
  }
}

class TrapAppShell extends ConsumerStatefulWidget {
  const TrapAppShell({super.key, required this.initialRoute});

  final AppRoute initialRoute;

  @override
  ConsumerState<TrapAppShell> createState() => _TrapAppShellState();
}

class _TrapAppShellState extends ConsumerState<TrapAppShell> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedRouteProvider.notifier).select(widget.initialRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoute = ref.watch(selectedRouteProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: AppRoute.values.indexOf(selectedRoute),
          children: const [
            FeedPage(),
            MapaPage(),
            _RoutePlaceholder(title: 'Criar'),
            InboxPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: TrapBottomMenu(
        selectedRoute: selectedRoute,
        onRouteSelected: (route) {
          ref.read(selectedRouteProvider.notifier).select(route);
          Navigator.of(context).pushReplacementNamed(route.path);
        },
      ),
    );
  }
}

class _RoutePlaceholder extends StatelessWidget {
  const _RoutePlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
