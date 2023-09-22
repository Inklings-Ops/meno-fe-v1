import 'package:flutter/material.dart';
import 'package:meno_fe_v1/core/theme/m_theme.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook.directories.g.dart';

void main() => runApp(const WidgetBookApp());

@widgetbook.App()
class WidgetBookApp extends StatelessWidget {
  const WidgetBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        ThemeAddon(
          themes: [
            WidgetbookTheme(name: "Light Theme", data: MTheme.light),
            WidgetbookTheme(name: "Dark Theme", data: MTheme.dark),
          ],
          themeBuilder: (context, theme, child) {
            return AppTheme(
              data: theme,
              child: child,
            );
          },
        ),
      ],
    );
  }
}

class AppTheme extends InheritedWidget {
  const AppTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final ThemeData data;

  static ThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return data != oldWidget.data;
  }
}
