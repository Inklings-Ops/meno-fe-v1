import 'package:flutter/material.dart';

class MInternal {
  static T resolve<T>(bool isLight, T lightThemeValue, T darkThemeValue) {
    return isLight ? lightThemeValue : darkThemeValue;
  }

  /// Convenience method for easier use of [MaterialStateProperty.all].
  static MaterialStateProperty<T> all<T>(T value) {
    return MaterialStateProperty.all(value);
  }

  /// Convenience method for easier use of [MaterialStateProperty.resolveWith].
  static MaterialStateProperty<T?> resolveWith<T>({
    required T defaultValue,
    T? pressedValue,
    T? disabledValue,
    T? hoveredValue,
    String? parent,
    T? selectedValue,
  }) {
    return MaterialStateProperty.resolveWith((states) {
      // disabled
      if (states.contains(MaterialState.disabled) && disabledValue != null) {
        return disabledValue;
      }

      // pressed / focused
      if (states.any({MaterialState.pressed, MaterialState.focused}.contains) &&
          pressedValue != null) {
        return pressedValue;
      }
      // hovered
      if (states.contains(MaterialState.hovered) && hoveredValue != null) {
        return hoveredValue;
      }

      // selected
      if (states.contains(MaterialState.selected) && selectedValue != null) {
        return selectedValue;
      }
      // default
      return defaultValue;
    });
  }
}
