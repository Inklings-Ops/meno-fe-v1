import 'package:fpdart/fpdart.dart';
import 'package:meno/core/core.dart';
import 'package:meno/features/settings/domain/domain.dart';
import 'package:meno/shared/domain/domain.dart';

abstract interface class ISettingsRepository {
  Option<UserSettings> getSettings(Id userId);

  Future<Either<MenoException, Unit>> updateSettings(
    Id userId,
    UserSettings settings,
  );

  Future<Either<MenoException, Unit>> syncFromRemote(Id userId);
}
