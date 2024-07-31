import 'package:injectable/injectable.dart';
import 'package:meno_fe_v1/src/features/settings/settings.dart';

@Injectable(as: ISettingsFacade)
class SettingsFacade implements ISettingsFacade {
  SettingsFacade({required SettingsLocalDatasource local}) : _local = local;
  final SettingsLocalDatasource _local;

  @override
  Future<void> get clearCache => _local.clearCache;

  @override
  Future<void> get completeOnboarding => _local.completeOnboarding;

  @override
  bool get isOnboarded => _local.isOnboard;
}
