import 'package:figma_layout_grid/figma_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/router/router.dart';

class MenoApp extends ConsumerStatefulWidget {
  const MenoApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenoAppState();
}

class _MenoAppState extends ConsumerState<MenoApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (_, child) => MaterialApp.router(
        theme: MTheme.light,
        darkTheme: MTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.sp)),
          child: LayoutGrid(
            builder: (context) => child!,
            rowsParams: const RowsParams(height: 8),
            columnsParams: const ColumnsParams(count: 4, gutter: 8, margin: 16),
          ),
        ),
      ),
    );
  }
}
