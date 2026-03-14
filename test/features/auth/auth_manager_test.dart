import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/onboarding/services/onboarding_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthHttpService, AuthLocalService, OnboardingService])
import 'auth_manager_test.mocks.dart';

void main() {
  late AuthManager manager;
  late MockAuthHttpService mockHttp;
  late MockAuthLocalService mockLocal;
  late StreamController<UserCredentialDto?> authChangedController;

  final tUserId = Id.unique().getOrCrash();

  provideDummy<UserCredentialDto>(
    UserCredentialDto(
      token: '',
      user: UserDto(id: tUserId, fullName: '', email: ''),
    ),
  );

  provideDummy<UserCredential>(
    UserCredential(
      user: User.empty.copyWith(id: Id.fromString(tUserId)),
      session: Session.empty,
    ),
  );

  setUp(() {
    mockHttp = MockAuthHttpService();
    mockLocal = MockAuthLocalService();
    authChangedController = StreamController<UserCredentialDto?>.broadcast();

    when(
      mockLocal.onCredentialChanged,
    ).thenAnswer((_) => authChangedController.stream);

    manager = AuthManager(http: mockHttp, local: mockLocal);
  });

  tearDown(() {
    authChangedController.close();
  });

  group('AuthManager', () {
    final tUserDto = UserDto(
      id: tUserId,
      email: 'test@example.com',
      fullName: 'Test User',
    );
    final tUserCredentialDto = UserCredentialDto(
      token: 'access_token',
      user: tUserDto,
    );

    test('init loads accounts and current credential', () async {
      when(
        mockLocal.getAllAccounts(),
      ).thenAnswer((_) async => {tUserId: tUserCredentialDto});
      when(
        mockLocal.getCredential(),
      ).thenAnswer((_) async => tUserCredentialDto);

      manager.initialize.run();

      expect(manager.activeUserId.value.getOrCrash(), tUserId);
      expect(manager.isAuthenticated, isTrue);
      expect(manager.accounts.value.length, 1);
    });

    test('login command handles successful authentication', () async {
      // Use explicit values instead of matchers to avoid anyNamed issues
      when(
        mockHttp.login(
          email: 'test@example.com',
          password: 'Password123!',
          pushNotificationToken: anyNamed('pushNotificationToken'),
        ),
      ).thenAnswer((_) async => tUserCredentialDto);

      when(mockLocal.saveCredential(any)).thenAnswer((_) async {});

      final result = await manager.login.runAsync(
        LoginArgs(Email('test@example.com'), Password.login('Password123!')),
      );

      expect(result.user.id.getOrCrash(), tUserId);
      expect(manager.activeUserId.value.getOrCrash(), tUserId);
      verify(mockLocal.saveCredential(tUserCredentialDto)).called(1);
    });

    test('logout command clears local credentials', () async {
      when(mockLocal.clearCredential()).thenAnswer((_) async {});

      await manager.logout.runAsync();

      expect(manager.activeUserId.value, Id.empty);
      verify(mockLocal.clearCredential()).called(1);
    });

    test('onAuthChanged updates state when credential emitted', () async {
      authChangedController.add(tUserCredentialDto);

      // Wait for stream event to be processed
      await Future.delayed(const Duration(milliseconds: 10));

      expect(manager.activeUserId.value.getOrCrash(), tUserId);
      expect(manager.lastKnownUser.value.fullName.getOrCrash(), 'Test User');
    });

    test('register command handles successful authentication', () async {
      when(
        mockHttp.register(
          fullName: anyNamed('fullName'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => tUserCredentialDto);
      when(mockLocal.saveCredential(any)).thenAnswer((_) async {});

      final result = await manager.register.runAsync(
        RegisterArgs(
          fullName: SingleLineString('Test User'),
          email: Email('test@example.com'),
          password: Password.register('Password123!'),
        ),
      );

      expect(result.user.id.getOrCrash(), tUserId);
      verify(mockLocal.saveCredential(tUserCredentialDto)).called(1);
    });

    test('switchAccount updates active user', () async {
      final tOtherId = Id.unique();
      final tOtherCredential = UserCredential(
        user: User.empty.copyWith(id: tOtherId),
        session: Session.empty,
      );
      manager.accounts.value[tOtherId] = tOtherCredential;

      when(mockLocal.switchActiveUser(any)).thenAnswer((_) async {});

      await manager.switchAccount.runAsync(tOtherId);

      expect(manager.activeUserId.value, tOtherId);
      verify(mockLocal.switchActiveUser(tOtherId.getOrCrash())).called(1);
    });

    test('requestOtp calls http service', () async {
      when(
        mockHttp.requestOtp(email: anyNamed('email'), type: anyNamed('type')),
      ).thenAnswer((_) async {});

      await manager.requestOtp.runAsync(
        OtpRequestArgs(
          email: Email('test@example.com'),
          type: OtpType.emailVerification,
        ),
      );

      verify(
        mockHttp.requestOtp(
          email: 'test@example.com',
          type: 'email_verification',
        ),
      ).called(1);
    });

    test('deleteAccount calls http and then logouts', () async {
      when(mockHttp.deleteUser(any)).thenAnswer((_) async {});
      when(mockLocal.clearCredential()).thenAnswer((_) async {});

      await manager.deleteAccount.runAsync();

      // Wait for piped command to execute
      await Future.delayed(const Duration(milliseconds: 50));

      verify(mockHttp.deleteUser(any)).called(1);
      verify(mockLocal.clearCredential()).called(1);
      expect(manager.activeUserId.value, Id.empty);
    });
  });
}
