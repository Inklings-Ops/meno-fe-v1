import 'package:fpdart/fpdart.dart';
import 'package:meno/core/exceptions/meno_exception.dart';
import 'package:meno/features/settings/domain/domain.dart';
import 'package:meno/features/settings/infrastructure/infrastructure.dart';
import 'package:meno/shared/domain/value_objects/id.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  const SettingsRepositoryImpl({
    required SettingsHttpDataSource http,
    required SettingsLocalDataSource local,
  }) : _http = http,
       _local = local;

  final SettingsHttpDataSource _http;
  final SettingsLocalDataSource _local;

  @override
  Option<UserSettings> getSettings(Id userId) {
    final settings = _local.getUserSettings(userId.getOrCrash());
    if (settings == null) return const None();
    return Some(settings.toDomain);
  }

  @override
  Future<Either<MenoException, Unit>> syncFromRemote(Id userId) async {
    try {
      final response = await _http.getUserSettings();
      await _local.saveUserSettings(userId.getOrCrash(), response);
      return const Right(unit);
    } catch (e) {
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }

  @override
  Future<Either<MenoException, Unit>> updateSettings(
    Id userId,
    UserSettings settings,
  ) async {
    try {
      // TODO(gettoknowdavid): Handle remote user settings updates.
      await _local.saveUserSettings(userId.getOrCrash(), settings.toDto);
      return const Right(unit);
    } catch (e) {
      if (e is MenoException) return Left(e);
      return Left(MenoException(e.toString()));
    }
  }
}
