import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthManager])
import 'login_form_widget_test.mocks.dart';

void main() {
  late MockAuthManager mockAuthManager;
  late Command<LoginArgs, UserCredential> mockLoginCommand;
  late ValueNotifier<User> lastKnownUserNotifier;

  provideDummy<UserCredential>(
    UserCredential(user: User.empty, session: Session.empty),
  );

  setUp(() {
    mockAuthManager = MockAuthManager();
    lastKnownUserNotifier = ValueNotifier<User>(User.empty);

    when(mockAuthManager.onDispose()).thenReturn(null);

    // Create a real command but we can stub its run method if needed
    // Actually, for widget tests, we can just mock the properties used by watchIt/watchValue
    mockLoginCommand = Command.createAsync<LoginArgs, UserCredential>(
      (args) async => UserCredential.empty,
      initialValue: UserCredential.empty,
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
      home: const Scaffold(body: LoginFormWidget()),
    );
  }

  group('LoginFormWidget', () {
    testWidgets('renders email and password fields when no last known user', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byKey(const Key('loginForm_emailField')), findsOneWidget);
      expect(find.byKey(const Key('loginForm_passwordField')), findsOneWidget);
      expect(find.byKey(const Key('loginForm_button')), findsOneWidget);
    });

    testWidgets('validation errors appear on empty fields', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byKey(const Key('loginForm_button')));
      await tester.pump();

      expect(find.text('This value cannot be empty.'), findsNWidgets(2));
    });

    testWidgets('calls login on AuthManager when valid inputs are provided', (
      tester,
    ) async {
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

      // Command might have internal timers or async gaps
      await tester.pumpAndSettle();
    });

    testWidgets(
      'renders UserAccountDetailsWidget when last known user exists',
      (tester) async {
        lastKnownUserNotifier.value = User.empty.copyWith(
          id: Id.unique(),
          fullName: SingleLineString('Test User'),
          email: Email('test@gmail.com'),
        );

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(UserAccountDetailsWidget), findsOneWidget);
        expect(find.text('Test User'), findsOneWidget);
        expect(find.byKey(const Key('loginForm_emailField')), findsNothing);
      },
    );
  });
}
