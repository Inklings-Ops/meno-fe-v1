import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/features/settings/pages/_pages.dart';

final class SettingsRoutes {
  const SettingsRoutes._();

  static List<RouteBase> get routes => [
    GoRoute(path: R.settings, builder: (_, __) => const SettingsPage()),
    GoRoute(
      path: R.notificationSettings,
      builder: (_, __) => const NotificationsSettingsPage(),
    ),
    GoRoute(
      path: R.securitySettings,
      builder: (_, __) => const SecuritySettingsPage(),
    ),
    GoRoute(path: R.about, builder: (_, __) => const AboutPage()),
  ];
}
