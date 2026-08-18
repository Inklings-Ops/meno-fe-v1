import 'package:flutter/material.dart';
import 'package:meno/_core/value_objects/id.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/broadcast/widgets/pre_stream_modal.dart';
import 'package:meno_design_system/meno_design_system.dart';

final class ModalRoutes {
  const ModalRoutes._();

  static List<RouteBase> get routes => [
    GoRoute(
      path: '/pre-stream/:broadcastId',
      parentNavigatorKey: RouterKeys.root,
      pageBuilder: (context, state) {
        final rawId = state.pathParameters['broadcastId']!;
        final broadcastId = Id.fromString(rawId);
        return ModalPage<dynamic>(
          isScrollControlled: true,
          child: PreStreamModal(broadcastId: broadcastId),
        );
      },
    ),
  ];
}

class ModalPage<T> extends Page<void> {
  const ModalPage({
    required this.child,
    super.key,
    this.constraints,
    this.isScrollControlled = false,
    this.useRootNavigator = false,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Widget child;
  final BoxConstraints? constraints;
  final bool isScrollControlled;
  final bool useRootNavigator;
  final bool isDismissible;
  final bool enableDrag;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      builder: (context) => Material(child: child),
      constraints: constraints,
      backgroundColor: MColorScheme.of(context).background,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: true,
      useSafeArea: true,
      settings: this,
    );
  }
}
