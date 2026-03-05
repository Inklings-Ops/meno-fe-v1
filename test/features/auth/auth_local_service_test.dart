import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/model/model.dart';
import 'package:meno/features/auth/services/auth_local_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SecureStorage])
import 'auth_local_service_test.mocks.dart';

void main() {
  late AuthLocalService service;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    service = AuthLocalService(mockStorage);
  });

  group('AuthLocalService', () {
    const tUserCredentialDto = UserCredentialDto(
      token: 'access_token',
      user: UserDto(
        id: 'user_id',
        email: 'test@example.com',
        fullName: 'Test User',
      ),
    );

    test('saveCredential saves all parts of the credential', () async {
      when(
        mockStorage.write(any, value: anyNamed('value')),
      ).thenAnswer((_) async {});
      when(
        mockStorage.read(StorageKeys.accounts),
      ).thenAnswer((_) async => null);

      await service.saveCredential(tUserCredentialDto);

      verify(
        mockStorage.write(
          StorageKeys.credential,
          value: jsonEncode(tUserCredentialDto.toJson()),
        ),
      ).called(1);
      verify(
        mockStorage.write(
          StorageKeys.userId,
          value: tUserCredentialDto.user.id,
        ),
      ).called(1);
      verify(
        mockStorage.write(
          StorageKeys.accessToken,
          value: tUserCredentialDto.token,
        ),
      ).called(1);
    });

    test('getCredential returns UserCredentialDto if token exists', () async {
      when(
        mockStorage.read(StorageKeys.accessToken),
      ).thenAnswer((_) async => 'access_token');
      when(
        mockStorage.read(StorageKeys.credential),
      ).thenAnswer((_) async => jsonEncode(tUserCredentialDto.toJson()));

      final result = await service.getCredential();

      expect(result?.token, tUserCredentialDto.token);
      expect(result?.user.id, tUserCredentialDto.user.id);
    });

    test('clearCredential deletes all keys', () async {
      when(mockStorage.delete(any)).thenAnswer((_) async {});

      await service.clearCredential();

      verify(mockStorage.delete(StorageKeys.credential)).called(1);
      verify(mockStorage.delete(StorageKeys.userId)).called(1);
      verify(mockStorage.delete(StorageKeys.accessToken)).called(1);
    });

    test('getSession returns Session if token exists', () async {
      when(
        mockStorage.read(StorageKeys.accessToken),
      ).thenAnswer((_) async => 'access_token');
      when(
        mockStorage.read(StorageKeys.refreshToken),
      ).thenAnswer((_) async => 'refresh_token');
      when(
        mockStorage.read(StorageKeys.sessionExpiry),
      ).thenAnswer((_) async => null);

      final session = await service.getSession();

      expect(session?.accessToken.getOrCrash(), 'access_token');
      expect(session?.refreshToken.getOrNull(), 'refresh_token');
    });

    test('updateSession writes all session data', () async {
      final session = Session.fromDto('new_token', refreshToken: 'new_refresh');
      when(
        mockStorage.write(any, value: anyNamed('value')),
      ).thenAnswer((_) async {});
      when(
        mockStorage.read(StorageKeys.accessToken),
      ).thenAnswer((_) async => 'new_token');
      when(
        mockStorage.read(StorageKeys.credential),
      ).thenAnswer((_) async => jsonEncode(tUserCredentialDto.toJson()));
      when(
        mockStorage.read(StorageKeys.accounts),
      ).thenAnswer((_) async => null);

      await service.updateSession(session);

      verify(
        mockStorage.write(StorageKeys.accessToken, value: 'new_token'),
      ).called(1);
      verify(
        mockStorage.write(StorageKeys.refreshToken, value: 'new_refresh'),
      ).called(1);
    });

    test('removeAccount deletes account from storage', () async {
      final accounts = {
        tUserCredentialDto.user.id: tUserCredentialDto.toJson(),
      };
      when(
        mockStorage.read(StorageKeys.accounts),
      ).thenAnswer((_) async => jsonEncode(accounts));
      when(
        mockStorage.read(StorageKeys.userId),
      ).thenAnswer((_) async => 'other_user');
      when(
        mockStorage.write(any, value: anyNamed('value')),
      ).thenAnswer((_) async {});
      when(mockStorage.delete(any)).thenAnswer((_) async {});

      await service.removeAccount(tUserCredentialDto.user.id);

      verify(mockStorage.delete(StorageKeys.accounts)).called(1);
    });
  });
}
