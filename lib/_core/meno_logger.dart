import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:logger/logger.dart';

mixin class MLogger {
  @protected
  Logger get log {
    try {
      return di<Logger>();
    } catch (e) {
      return Logger();
    }
  }
}
