import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/app/router/router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MenoApp extends StatelessWidget {
  const MenoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      darkTheme: MTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: di<MRouter>().routerConfig,
      theme: MTheme.light,
    );
  }
}
