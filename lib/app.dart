import 'package:figma_layout_grid/figma_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/router/m_router.dart';

final _mRouter = MRouter();

class MenoApp extends StatelessWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: MTheme.light,
      darkTheme: MTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: _mRouter.config(),
      builder: (context, child) {
        final isLight = Theme.of(context).brightness == Brightness.light;
        final color = isLight ? MColor.white : MColor.primary700;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(systemNavigationBarColor: color),
          child: LayoutGrid(
            rowsParams: const RowsParams(height: 8),
            columnsParams: const ColumnsParams(
              count: 4,
              gutter: 8,
              margin: 16,
            ),
            builder: (context) => child!,
          ),
        );
      },
    );
  }
}
