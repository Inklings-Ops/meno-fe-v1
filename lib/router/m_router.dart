import 'package:auto_route/auto_route.dart';
import 'package:meno_fe_v1/layout/m_layout.dart';
import 'package:meno_fe_v1/layout/pages.dart';
import 'package:meno_fe_v1/router/m_routes.dart';

part 'm_router.gr.dart';

@AutoRouterConfig()
class MRouter extends _$MRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: MRoutes.layout,
          page: MLayoutRoute.page,
          children: [
            AutoRoute(path: MRoutes.home, page: HomeRoute.page),
            AutoRoute(
              path: MRoutes.discover,
              page: DiscoverRoute.page,
              title: (context, data) => "Discover",
            ),
            AutoRoute(
              path: MRoutes.notes,
              page: NotesRoute.page,
              title: (context, data) => "Notes",
            ),
            AutoRoute(path: MRoutes.profile, page: ProfileRoute.page),
          ],
        ),
      ];
}
