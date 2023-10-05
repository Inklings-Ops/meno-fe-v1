import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

@lazySingleton
class JWTService {
  bool isExpired(String token) => JwtDecoder.isExpired(token);

  DateTime getExpiryDate(String token) => JwtDecoder.getExpirationDate(token);

  Map<String, dynamic>? decode(String token) => JwtDecoder.tryDecode(token);
}
