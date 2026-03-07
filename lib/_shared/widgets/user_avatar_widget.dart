import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/manager/user_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class UserAvatarWidget extends WatchingWidget {
  const UserAvatarWidget({this.onTap, super.key});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = watchValue((UserManager m) => m.currentUser).image;
    return MAvatar(
      radius: Insets.lg,
      url: image?.getUrl(),
      onTap: onTap,
      hasBorder: false,
    );
  }
}
