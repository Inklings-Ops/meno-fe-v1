import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/onboarding/services/onboarding_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  AuthHttpService,
  AuthLocalService,
  OnboardingService,
  PushNotificationsService,
])
import 'auth_error_test.mocks.dart';

void main() {
  late AuthManager manager;
  late MockAuthHttpService mockHttp;
  late MockAuthLocalService mockLocal;
  late MockPushNotificationsService mockPushService;
  late StreamController<UserCredentialDto?> authChangedController;
  Object? lastGlobalError;

  provideDummy<UserCredentialDto>(
    const UserCredentialDto(
      token: '',
      user: UserDto(id: '', fullName: '', email: ''),
    ),
  );

  setUp(() {
    mockHttp = MockAuthHttpService();
    mockLocal = MockAuthLocalService();
    mockPushService = MockPushNotificationsService();
    authChangedController = StreamController<UserCredentialDto?>.broadcast();
    lastGlobalError = null;

    // Spy on global exception handler
    Command.globalExceptionHandler = (commandError, stackTrace) {
      lastGlobalError = commandError.error;
    };

    when(
      mockLocal.onCredentialChanged,
    ).thenAnswer((_) => authChangedController.stream);

    manager = AuthManager(
      http: mockHttp,
      local: mockLocal,
      pushService: mockPushService,
    );
  });

  tearDown(() {
    authChangedController.close();
    Command.globalExceptionHandler = null;
  });

  group('AuthManager Error Handling (with MenoExceptionFilter)', () {
    const tEmail = 'test@example.com';
    const tPassword = 'Password123!';

    test('ServerException: Routed to GLOBAL only', () async {
      when(
        mockHttp.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
          pushNotificationToken: anyNamed('pushNotificationToken'),
        ),
      ).thenThrow(const ServerException());

      try {
        await manager.login.runAsync(
          LoginArgs(Email(tEmail), Password.login(tPassword)),
        );
      } catch (_) {}

      // Filter says ServerException -> globalHandler only
      expect(
        manager.login.errors.value,
        isNull,
        reason: 'ServerException should not be local',
      );
      expect(
        lastGlobalError,
        isA<ServerException>(),
        reason: 'ServerException should be global',
      );
    });

    test('ValidationException: Routed to BOTH local and global', () async {
      final validationError = ValidationException({'email': 'Already taken'});
      when(
        mockHttp.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
          pushNotificationToken: anyNamed('pushNotificationToken'),
        ),
      ).thenThrow(validationError);

      // Must have listener for local errors to be preserved
      manager.login.errors.addListener(() {});

      try {
        await manager.login.runAsync(
          LoginArgs(Email(tEmail), Password.login(tPassword)),
        );
      } catch (_) {}

      // Filter says ValidationException -> localAndGlobalHandler
      expect(
        manager.login.errors.value?.error,
        isA<ValidationException>(),
        reason: 'ValidationException should be local',
      );
      expect(
        lastGlobalError,
        isA<ValidationException>(),
        reason: 'ValidationException should be global',
      );
    });

    test('Unauthenticated: Routed to GLOBAL only', () async {
      when(
        mockHttp.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
          pushNotificationToken: anyNamed('pushNotificationToken'),
        ),
      ).thenThrow(const Unauthenticated());

      try {
        await manager.login.runAsync(
          LoginArgs(Email(tEmail), Password.login(tPassword)),
        );
      } catch (_) {}

      // Filter says Unauthenticated -> globalHandler only
      expect(
        manager.login.errors.value,
        isNull,
        reason: 'Unauthenticated should not be local',
      );
      expect(
        lastGlobalError,
        isA<Unauthenticated>(),
        reason: 'Unauthenticated should be global',
      );
    });

    test('NetworkException: Routed to GLOBAL only', () async {
      when(
        mockHttp.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
          pushNotificationToken: anyNamed('pushNotificationToken'),
        ),
      ).thenThrow(const NetworkException());

      try {
        await manager.login.runAsync(
          LoginArgs(Email(tEmail), Password.login(tPassword)),
        );
      } catch (_) {}

      expect(
        manager.login.errors.value,
        isNull,
        reason: 'NetworkException should not be local',
      );
      expect(
        lastGlobalError,
        isA<NetworkException>(),
        reason: 'NetworkException should be global',
      );
    });
    group('Generic Exceptions', () {
      test('Non-MenoException: Routed to GLOBAL only', () async {
        when(
          mockHttp.login(
            email: anyNamed('email'),
            password: anyNamed('password'),
            pushNotificationToken: anyNamed('pushNotificationToken'),
          ),
        ).thenThrow(Exception('Raw dart exception'));

        try {
          await manager.login.runAsync(
            LoginArgs(Email(tEmail), Password.login(tPassword)),
          );
        } catch (_) {}

        expect(manager.login.errors.value, isNull);
        expect(lastGlobalError, isA<Exception>());
      });
    });
  });
}
