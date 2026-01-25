// TODO: Implement AppDrawer
// This widget provides the app's navigation drawer

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String userName;
  final String userInitial;
  final VoidCallback onLoginTap;

  const AppDrawer({
    super.key,
    required this.isLoggedIn,
    required this.userName,
    required this.userInitial,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement drawer UI
    return const Drawer(
      child: Placeholder(),
    );
  }
}
