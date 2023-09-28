import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(name: 'Env', path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'MENO_API_URL')
  static final String menoApiUrl = _Env.menoApiUrl;

  @EnviedField(varName: 'BIBLE_API_URL')
  static final String bibleApiUrl = _Env.bibleApiUrl;
}
