import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(name: 'Env', path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'MENO_API_URL')
  static final String menoApiUrl = _Env.menoApiUrl;

  @EnviedField(varName: 'WEB_SOCKET_URL')
  static final String webSocketUrl = _Env.webSocketUrl;

  @EnviedField(varName: 'BIBLE_API_URL')
  static final String bibleApiUrl = _Env.bibleApiUrl;

  @EnviedField(varName: 'MENO_LIVEKIT_URL')
  static final String menoLiveKitUrl = _Env.menoLiveKitUrl;
}
