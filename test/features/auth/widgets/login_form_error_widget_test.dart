import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_core/keys/meno_keys.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/auth/widgets/login_form_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:mockito/mockito.dart';

// Reuse mocks
import 'login_form_widget_test.mocks.dart';

void main() {
  late MockAuthManager mockAuthManager;
  late Command<LoginArgs, UserCredential> mockLoginCommand;
  late ValueNotifier<User> lastKnownUserNotifier;

  setUp(() {
    mockAuthManager = MockAuthManager();
    lastKnownUserNotifier = ValueNotifier<User>(User.empty);
    when(mockAuthManager.onDispose()).thenReturn(null);

    mockLoginCommand = Command.createAsync<LoginArgs, UserCredential>(
      (args) async => throw const ServerException(),
      initialValue: UserCredential.empty,
      errorFilterFn: menoExceptionFilter,
    );

    when(mockAuthManager.login).thenReturn(mockLoginCommand);
    when(mockAuthManager.lastKnownUser).thenReturn(lastKnownUserNotifier);

    GetIt.I.registerSingleton<AuthManager>(mockAuthManager);
  });

  tearDown(() {
    GetIt.I.unregister<AuthManager>();
    mockLoginCommand.dispose();
    lastKnownUserNotifier.dispose();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: MTheme.light,
      scaffoldMessengerKey: MenoKeys.scaffoldMessengerKey,
      home: const Scaffold(body: LoginFormWidget()),
    );
  }

  group('LoginFormWidget Error UI', () {
    testWidgets('fields are disabled when login is running', (tester) async {
      // Stub a long running task
      final completer = Completer<UserCredential>();
      final longRunningCommand = Command.createAsync<LoginArgs, UserCredential>(
        (args) => completer.future,
        initialValue: UserCredential.empty,
      );
      when(mockAuthManager.login).thenReturn(longRunningCommand);

      await tester.pumpWidget(createWidgetUnderTest());

      // Start login
      await tester.enterText(
        find.byKey(const Key('loginForm_emailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordField')),
        'Password123!',
      );
      await tester.tap(find.byKey(const Key('loginForm_button')));
      await tester.pump(); // Start execution

      expect(longRunningCommand.isRunning.value, isTrue);

      // Verify fields are disabled (MTextFormField enabled prop)
      final emailField = tester.widget<MTextFormField>(
        find.byType(MTextFormField).first,
      );
      expect(emailField.enabled, isFalse);

      completer.complete(UserCredential.empty);
      await tester.pumpAndSettle();
      longRunningCommand.dispose();
    });

    testWidgets('shows snackbar on global error (ServerException)', (
      tester,
    ) async {
      // Configure global handler
      configureGlobalExceptionHandler();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.byKey(const Key('loginForm_emailField')),
        'test@gmail.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordField')),
        'Password123!',
      );

      await tester.tap(find.byKey(const Key('loginForm_button')));

      // Wait for command to finish and global handler to be called
      await tester.pumpAndSettle();

      // MenoExceptionFilter routes ServerException to globalHandler
      // GlobalExceptionHandler shows snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Server error occurred.'), findsOneWidget);

      Command.globalExceptionHandler = null;
    });
  });
}
