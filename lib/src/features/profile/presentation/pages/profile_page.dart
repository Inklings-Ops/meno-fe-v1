import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets/my_profile_page.dart';

class ProfilePage extends HookConsumerWidget {
  final String? id;
  const ProfilePage({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id != null) {
      return Scaffold(
        body: Center(
          child: Text(
            id!,
            style: MTextStyle.heading1Bold,
          ),
        ),
      );
    } else {
      return const MyProfilePage();
    }
  }
}
