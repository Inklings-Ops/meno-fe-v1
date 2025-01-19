import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/m_keys.dart';

@injectable
class BroadcastLocalDatasource {
  /// Creates a new `BroadcastLocalDatasource` object.
  const BroadcastLocalDatasource({
    required SecureStorageService storage,
  }) : _storage = storage;

  /// The secure storage service.
  final SecureStorageService _storage;

  Future<bool> get hasBroadcast => _storage.hasKey(MKeys.broadcastDetailsKey);

  Future<void> clearBroadcastDetails() {
    return _storage.delete(MKeys.broadcastDetailsKey);
  }

  Future<BroadcastDto?> getBroadcastDetails() async {
    final jsonString = await _storage.read(MKeys.broadcastDetailsKey);
    if (jsonString == null) return null;
    final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
    return BroadcastDto.fromJson(decodedJson);
  }

  Future<void> saveBroadcastDetails(BroadcastDto? dto) async {
    if (dto == null) return;
    final encodedString = jsonEncode(dto.toJson());
    return _storage.write(MKeys.broadcastDetailsKey, value: encodedString);
  }
}
