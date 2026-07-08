import 'package:flutter/material.dart';

enum AppRoute {
  feed(path: '/feed', label: 'FEED', icon: Icons.grid_view_rounded),
  map(path: '/mapa', label: 'MAPA', icon: Icons.my_location_rounded),
  create(
    path: '/criar',
    label: 'CRIAR',
    icon: Icons.add_rounded,
    isPrimaryAction: true,
  ),
  inbox(
    path: '/inbox',
    label: 'INBOX',
    icon: Icons.chat_bubble_outline_rounded,
  ),
  profile(path: '/perfil', label: 'PERFIL', icon: Icons.person_outline_rounded);

  const AppRoute({
    required this.path,
    required this.label,
    required this.icon,
    this.isPrimaryAction = false,
  });

  final String path;
  final String label;
  final IconData icon;
  final bool isPrimaryAction;
}
