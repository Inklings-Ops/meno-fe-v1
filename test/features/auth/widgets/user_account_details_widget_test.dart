import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/widgets/user_account_details_widget.dart';
import 'package:meno_design_system/meno_design_system.dart';

void main() {
  group('UserAccountDetailsWidget', () {
    final tUser = User.empty.copyWith(
      id: Id.unique(),
      fullName: SingleLineString('Test User'),
      email: Email('test@gmail.com'),
    );

    testWidgets('renders user name correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MTheme.light,
          home: Scaffold(body: UserAccountDetailsWidget(user: tUser)),
        ),
      );

      expect(find.text('Welcome back,'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('renders switch account text when action is provided', (
      tester,
    ) async {
      var actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: MTheme.light,
          home: Scaffold(
            body: UserAccountDetailsWidget(
              user: tUser,
              action: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Switch account'), findsOneWidget);

      await tester.tap(find.text('Switch account'));
      expect(actionCalled, isTrue);
    });

    testWidgets('does not render switch account text when action is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MTheme.light,
          home: Scaffold(body: UserAccountDetailsWidget(user: tUser)),
        ),
      );

      expect(find.text('Switch account'), findsNothing);
    });
  });
}
