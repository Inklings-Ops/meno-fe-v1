import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/model/dtos/dtos.dart';
import 'package:meno/features/auth/services/auth_http_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([HttpClient])
import 'auth_http_service_test.mocks.dart';

void main() {
  late AuthHttpService service;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    service = AuthHttpService(mockClient);
  });

  group('AuthHttpService', () {
    const tEmail = 'test@example.com';
    const tPassword = 'Password123!';
    const tFullName = 'Test User';

    const tUserCredentialDto = UserCredentialDto(
      token: 'access_token',
      user: UserDto(
        id: 'user_id',
        email: 'test@example.com',
        fullName: 'Test User',
        verified: true,
      ),
    );

    test('login returns UserCredentialDto on success', () async {
      when(
        mockClient.post<UserCredentialDto>(
          any,
          data: anyNamed('data'),
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => tUserCredentialDto);

      final result = await service.login(email: tEmail, password: tPassword);

      expect(result, tUserCredentialDto);
      verify(
        mockClient.post<UserCredentialDto>(
          '/users/signin',
          data: {
            'email': tEmail,
            'password': tPassword,
            'pushNotificationToken': null,
          },
          fromJson: anyNamed('fromJson'),
        ),
      ).called(1);
    });

    test('register returns UserCredentialDto on success', () async {
      when(
        mockClient.post<UserCredentialDto>(
          any,
          data: anyNamed('data'),
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => tUserCredentialDto);

      final result = await service.register(
        fullName: tFullName,
        email: tEmail,
        password: tPassword,
      );

      expect(result, tUserCredentialDto);
      verify(
        mockClient.post<UserCredentialDto>(
          '/users/signup',
          data: {
            'fullName': tFullName,
            'email': tEmail,
            'password': tPassword,
            'pushNotificationToken': null,
          },
          fromJson: anyNamed('fromJson'),
        ),
      ).called(1);
    });

    test('verifyEmail calls postUnit', () async {
      when(
        mockClient.postUnit(any, data: anyNamed('data')),
      ).thenAnswer((_) async {});

      await service.verifyEmail(email: tEmail, code: '123456');

      verify(
        mockClient.postUnit(
          '/users/email/verify',
          data: {'email': tEmail, 'code': '123456'},
        ),
      ).called(1);
    });

    test('googleSignIn returns UserCredentialDto', () async {
      when(
        mockClient.post<UserCredentialDto>(
          any,
          data: anyNamed('data'),
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => tUserCredentialDto);

      final result = await service.googleSignIn(idToken: 'token123');

      expect(result, tUserCredentialDto);
      verify(
        mockClient.post<UserCredentialDto>(
          '/users/signin/google',
          data: {'idToken': 'token123', 'pushNotificationToken': null},
          fromJson: anyNamed('fromJson'),
        ),
      ).called(1);
    });

    test('changePassword calls postUnit', () async {
      when(
        mockClient.postUnit(any, data: anyNamed('data')),
      ).thenAnswer((_) async {});

      await service.changePassword(currentPassword: 'old', newPassword: 'new');

      verify(
        mockClient.postUnit(
          '/users/password/change',
          data: {'currentPassword': 'old', 'newPassword': 'new'},
        ),
      ).called(1);
    });

    test('resetPassword calls postUnit', () async {
      when(
        mockClient.postUnit(any, data: anyNamed('data')),
      ).thenAnswer((_) async {});

      await service.resetPassword(
        email: tEmail,
        code: '123',
        newPassword: 'new',
      );

      verify(
        mockClient.postUnit(
          '/users/password/reset',
          data: {'email': tEmail, 'code': '123', 'newPassword': 'new'},
        ),
      ).called(1);
    });

    test('deleteUser calls deleteUnit', () async {
      when(
        mockClient.deleteUnit(any, cancelToken: anyNamed('cancelToken')),
      ).thenAnswer((_) async {});

      await service.deleteUser();

      verify(
        mockClient.deleteUnit('/users', cancelToken: anyNamed('cancelToken')),
      ).called(1);
    });
  });
}
