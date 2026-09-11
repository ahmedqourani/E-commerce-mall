import 'package:e_commerce_mall/core/theme/app_theme.dart';
import 'package:e_commerce_mall/features/auth/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Covers the flow the redesign had to deliver: Login → Register → Login, plus
/// the validation rules on both forms.
///
/// Nothing here submits a *valid* form, so no request is ever issued — every
/// assertion is reachable without a network stub.
void main() {
  /// A phone-sized surface, so the footer link is on screen and taps land where
  /// they would on a device.
  Future<void> pumpLogin(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const LoginView()),
    );
    await tester.pumpAndSettle();
  }

  /// Scrolls the target into view before tapping it. The register screen is
  /// taller than a phone viewport, so its footer link starts below the fold and
  /// a bare `tap` would land on nothing.
  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  group('login screen', () {
    testWidgets('renders the redesigned form', (tester) async {
      await pumpLogin(tester);

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      // The register call-to-action.
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('refuses to submit an empty form', (tester) async {
      await pumpLogin(tester);

      await tapText(tester, 'Login');

      expect(find.text('Email or username is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      // Still on login — nothing navigated.
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('does not reject a username for not looking like an email',
        (tester) async {
      // The API authenticates by username, so "emilys" must pass validation.
      await pumpLogin(tester);

      await tester.enterText(find.byType(TextFormField).at(0), 'emilys');
      await tester.pumpAndSettle();

      expect(find.text('Email or username is required'), findsNothing);
      expect(find.textContaining('valid email'), findsNothing);
    });

    testWidgets('password visibility toggle still works', (tester) async {
      await pumpLogin(tester);

      expect(find.byTooltip('Show password'), findsOneWidget);
      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Hide password'), findsOneWidget);
    });
  });

  group('navigation flow', () {
    testWidgets('Register opens the register screen, Login comes back',
        (tester) async {
      await pumpLogin(tester);

      await tapText(tester, 'Register');

      // Arrived at a real second screen, not a swapped label.
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Welcome Back'), findsNothing);

      await tapText(tester, 'Login');

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Create Account'), findsNothing);
    });
  });

  group('register validation', () {
    Future<void> pumpRegister(WidgetTester tester) async {
      await pumpLogin(tester);
      await tapText(tester, 'Register');
    }

    testWidgets('reports every empty field', (tester) async {
      await pumpRegister(tester);

      await tapText(tester, 'Register');

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      // Did not navigate away.
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('rejects a malformed email', (tester) async {
      await pumpRegister(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'not-an-email');
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('accepts a well-formed email', (tester) async {
      await pumpRegister(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'ada@example.com');
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email address'), findsNothing);
      expect(find.text('Email is required'), findsNothing);
    });

    testWidgets('rejects a confirmation that does not match', (tester) async {
      await pumpRegister(tester);

      await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
      await tester.enterText(find.byType(TextFormField).at(3), 'secret124');
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('accepts a matching confirmation', (tester) async {
      await pumpRegister(tester);

      await tester.enterText(find.byType(TextFormField).at(2), 'secret123');
      await tester.enterText(find.byType(TextFormField).at(3), 'secret123');
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsNothing);
      expect(find.text('Please confirm your password'), findsNothing);
    });
  });
}
