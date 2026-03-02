import 'package:flutter/material.dart' show ThemeMode;

enum UserDisplay {
  system('system'),
  dark('dark'),
  light('light');

  const UserDisplay(this.value);

  factory UserDisplay.fromJson(dynamic value) {
    if (value is! String) return UserDisplay.system;
    return switch (value) {
      'dark' => UserDisplay.dark,
      'light' => UserDisplay.light,
      _ => UserDisplay.system,
    };
  }

  final String value;

  String toJson() => value;
}

extension DisplayX on ThemeMode {
  UserDisplay get toDisplay => switch (this) {
    ThemeMode.dark => UserDisplay.dark,
    ThemeMode.light => UserDisplay.light,
    ThemeMode.system => UserDisplay.system,
  };
}

extension ThemeModeX on UserDisplay {
  ThemeMode get toThemeMode => switch (this) {
    UserDisplay.dark => ThemeMode.dark,
    UserDisplay.light => ThemeMode.light,
    UserDisplay.system => ThemeMode.system,
  };
}
