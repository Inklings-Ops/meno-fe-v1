import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

@RoutePage()
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Discover")),
    );
  }
}

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Notes")),
    );
  }
}

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: MText("Profile")),
    );
  }
}
