import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'my_profile_page.dart';

class ProfilePage extends HookConsumerWidget {
  final String? id;
  const ProfilePage({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id != null) {
      return const Scaffold();
    } else {
      return const MyProfilePage();
    }
  }
}
