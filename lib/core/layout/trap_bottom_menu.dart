import 'package:flutter/material.dart';

import '../routes/app_route.dart';

const _acidGreen = Color(0xFFD7FF00);

class TrapBottomMenu extends StatelessWidget {
  const TrapBottomMenu({
    super.key,
    required this.selectedRoute,
    required this.onRouteSelected,
  });

  final AppRoute selectedRoute;
  final ValueChanged<AppRoute> onRouteSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 84,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AppRoute.values.map((route) {
              if (route.isPrimaryAction) {
                return _PrimaryMenuAction(
                  route: route,
                  onTap: () => onRouteSelected(route),
                );
              }

              return _MenuItem(
                route: route,
                isSelected: selectedRoute == route,
                onTap: () => onRouteSelected(route),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  final AppRoute route;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _acidGreen : const Color(0xFF8D8D8D);

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: route.label,
        child: InkResponse(
          onTap: onTap,
          radius: 32,
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(route.icon, color: color, size: 22),
                const SizedBox(height: 6),
                Text(
                  route.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryMenuAction extends StatelessWidget {
  const _PrimaryMenuAction({required this.route, required this.onTap});

  final AppRoute route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Semantics(
          button: true,
          label: route.label,
          child: Material(
            color: _acidGreen,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Icon(route.icon, color: Colors.black, size: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
