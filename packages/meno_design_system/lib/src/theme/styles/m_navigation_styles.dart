import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MNavigationStyles extends ThemeExtension<MNavigationStyles> {
  final AppBarTheme? appBarTheme;
  final BottomNavigationBarThemeData? bottomNavigationBarTheme;
  final TabBarTheme? tabBarTheme;
  final MColor? accentColor;
  final MTextStyle? actionTextStyle;

  MNavigationStyles({
    this.appBarTheme,
    this.bottomNavigationBarTheme,
    this.tabBarTheme,
    this.accentColor,
    this.actionTextStyle,
  });

  factory MNavigationStyles.$default({required MColorScheme colorScheme}) {
    return MNavigationStyles(
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: colorScheme.background,
        // titleSpacing: 0,
        toolbarHeight: 56,
        titleTextStyle: MTextStyle.bodyMedium,
        actionsIconTheme: IconThemeData(
          color: colorScheme.onBackground,
          size: 24,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: colorScheme.background,
        unselectedItemColor: colorScheme.inActive,
        selectedItemColor: colorScheme.primary,
        selectedIconTheme: IconThemeData(color: colorScheme.primary, size: 20),
        unselectedIconTheme:
            IconThemeData(color: colorScheme.inActive, size: 20),
        unselectedLabelStyle: MTextStyle.microMedium.copyWith(
          color: colorScheme.inActive,
        ),
        selectedLabelStyle: MTextStyle.microMedium.copyWith(
          color: colorScheme.primary,
        ),
      ),
      accentColor: MColor.secondary300,
      actionTextStyle: MTextStyle.captionMedium,
      tabBarTheme: TabBarTheme(
        labelStyle: MTextStyle.captionMedium,
        labelColor: colorScheme.primary,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        unselectedLabelStyle: MTextStyle.captionMedium,
        unselectedLabelColor: colorScheme.onBackgroundVariant,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: colorScheme.primary!),
          ),
        ),
      ),
    );
  }

  @override
  ThemeExtension<MNavigationStyles> copyWith({
    AppBarTheme? appBarTheme,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    TabBarTheme? tabBarTheme,
    MColor? accentColor,
    MTextStyle? actionTextStyle,
  }) {
    return MNavigationStyles(
      appBarTheme: appBarTheme ?? this.appBarTheme,
      tabBarTheme: tabBarTheme ?? this.tabBarTheme,
      accentColor: accentColor ?? this.accentColor,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      bottomNavigationBarTheme:
          bottomNavigationBarTheme ?? this.bottomNavigationBarTheme,
    );
  }

  @override
  ThemeExtension<MNavigationStyles> lerp(
    ThemeExtension<MNavigationStyles>? other,
    double t,
  ) {
    if (other is! MNavigationStyles) return this;
    return MNavigationStyles(
      appBarTheme: AppBarTheme.lerp(appBarTheme, other.appBarTheme, t),
      tabBarTheme: TabBarTheme.lerp(tabBarTheme!, other.tabBarTheme!, t),
      accentColor: MColor.lerp(accentColor, other.accentColor, t),
      actionTextStyle:
          MTextStyle.lerp(actionTextStyle, other.actionTextStyle, t),
      bottomNavigationBarTheme: BottomNavigationBarThemeData.lerp(
          bottomNavigationBarTheme, other.bottomNavigationBarTheme, t),
    );
  }

  static MNavigationStyles? of(BuildContext context) {
    return Theme.of(context).extension<MNavigationStyles>();
  }
}
