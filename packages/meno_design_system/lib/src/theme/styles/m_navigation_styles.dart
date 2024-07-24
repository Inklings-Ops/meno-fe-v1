import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MNavigationStyles extends ThemeExtension<MNavigationStyles> {
  final AppBarTheme? appBarTheme;
  final BottomNavigationBarThemeData? bottomNavigationBarTheme;
  final TabBarTheme? tabBarTheme;
  final MColor? accentColor;
  final TextStyle? actionTextStyle;

  MNavigationStyles({
    this.appBarTheme,
    this.bottomNavigationBarTheme,
    this.tabBarTheme,
    this.accentColor,
    this.actionTextStyle,
  });

  factory MNavigationStyles.$default(MColorScheme colors) {
    final iconSize = 20.toScale;
    return MNavigationStyles(
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: colors.background,
        toolbarHeight: 56.toScale,
        titleTextStyle: $styles.text.bodyMedium,
        actionsIconTheme: IconThemeData(
          color: colors.onBackground,
          size: 24.toScale,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: colors.background,
        unselectedItemColor: colors.inActive,
        selectedItemColor: colors.primary,
        selectedIconTheme: IconThemeData(color: colors.primary, size: iconSize),
        unselectedIconTheme: IconThemeData(
          color: colors.inActive,
          size: iconSize,
        ),
        unselectedLabelStyle: $styles.text.microMedium.copyWith(
          color: colors.inActive,
        ),
        selectedLabelStyle: $styles.text.microMedium.copyWith(
          color: colors.primary,
        ),
      ),
      accentColor: MColor.secondary300,
      actionTextStyle: $styles.text.captionMedium,
      tabBarTheme: TabBarTheme(
        labelStyle: $styles.text.captionMedium,
        labelColor: colors.primary,
        labelPadding: EdgeInsets.symmetric(horizontal: $styles.insets.small),
        unselectedLabelStyle: $styles.text.captionMedium,
        unselectedLabelColor: colors.onBackgroundVariant,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.toScale, color: colors.primary!),
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
    TextStyle? actionTextStyle,
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
          TextStyle.lerp(actionTextStyle, other.actionTextStyle, t),
      bottomNavigationBarTheme: BottomNavigationBarThemeData.lerp(
          bottomNavigationBarTheme, other.bottomNavigationBarTheme, t),
    );
  }

  static MNavigationStyles? of(BuildContext context) {
    return Theme.of(context).extension<MNavigationStyles>();
  }
}
