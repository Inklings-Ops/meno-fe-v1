import 'package:flutter/material.dart';

class MInternal {
  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  /// Convenience method for easier use of [WidgetStateProperty.all].
  static WidgetStateProperty<T> all<T>(T value) {
    return WidgetStateProperty.all(value);
  }

  /// Convenience method for easier use of [WidgetStateProperty.resolveWith].
  static WidgetStateProperty<T?> resolveWith<T>({
    required T defaultValue,
    T? pressedValue,
    T? disabledValue,
    T? hoveredValue,
    String? parent,
    T? selectedValue,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      // disabled
      if (states.contains(WidgetState.disabled) && disabledValue != null) {
        return disabledValue;
      }

      // pressed / focused
      if (states.any({WidgetState.pressed, WidgetState.focused}.contains) &&
          pressedValue != null) {
        return pressedValue;
      }
      // hovered
      if (states.contains(WidgetState.hovered) && hoveredValue != null) {
        return hoveredValue;
      }

      // selected
      if (states.contains(WidgetState.selected) && selectedValue != null) {
        return selectedValue;
      }
      // default
      return defaultValue;
    });
  }
}
