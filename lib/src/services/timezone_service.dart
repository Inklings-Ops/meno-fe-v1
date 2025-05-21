import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TimezoneService {
  Future<String> getLocalTimezone() async => FlutterTimezone.getLocalTimezone();
}
