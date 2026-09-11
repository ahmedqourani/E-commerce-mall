import 'package:e_commerce_mall/core/theme/app_theme.dart';
import 'package:e_commerce_mall/features/auth/view/login_view.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards against "Failed to interpolate TextStyles with different inherit
/// values." on the auth screens.
///
/// A hand-written `TextStyle(...)` carries `inherit: true`; every style Flutter
/// derives from a theme carries `inherit: false`. `TextStyle.lerp` asserts the
/// two ends of an animation agree, and the login form animates text styles in
/// places it does not own — `InputDecorator`'s label on focus and on
/// validation, and the `AnimatedDefaultTextStyle` inside every `Material`.
///
/// These tests pump *mid-animation* on purpose: `pumpAndSettle` would jump past
/// the interpolation that throws.
void main() {
  Future<void> pumpLogin(WidgetTester tester, ThemeData theme) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(theme: theme, home: const LoginView()));
    await tester.pumpAndSettle();
  }

  group('login screen text styles interpolate', () {
    for (final MapEntry<String, ThemeData> entry in <String, ThemeData>{
      'light': AppTheme.light,
      'dark': AppTheme.dark,
    }.entries) {
      testWidgets('through focus and validation (${entry.key})', (tester) async {
        await pumpLogin(tester, entry.value);

        // Focus: the transition InputDecorator runs over its label, hint and
        // border styles.
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump(const Duration(milliseconds: 40));
        await tester.pump(const Duration(milliseconds: 60));
        expect(tester.takeException(), isNull);

        // Validation: submitting empty fields makes the error text appear and
        // folds `errorStyle.color` into the floating label style. Nothing is
        // sent, so no network stub is needed.
        await tester.tap(find.text('Login'));
        await tester.pump(const Duration(milliseconds: 40));
        await tester.pump(const Duration(milliseconds: 60));
        expect(tester.takeException(), isNull);

        await tester.pumpAndSettle();
        expect(find.text('Email or username is required'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('through a light/dark theme change', (tester) async {
      // `AnimatedTheme` lerps the whole ThemeData, which lerps every component
      // style that carries a TextStyle — ButtonStyle.textStyle included.
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          home: const LoginView(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: const LoginView(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pump(const Duration(milliseconds: 80));
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('for the themed label/floating-label pair', (tester) async {
      // The pair `InputDecorator` interpolates directly. Any field in the app
      // that uses `labelText` relies on these two agreeing.
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: TextField(decoration: InputDecoration(labelText: 'Email')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField));
      await tester.pump(const Duration(milliseconds: 40));
      await tester.pump(const Duration(milliseconds: 60));
      expect(tester.takeException(), isNull);
    });
  });

  group('AuthTextStyles', () {
    testWidgets('match the ambient text theme\'s inherit flag', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (BuildContext ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      );

      final bool themeInherit = Theme.of(context).textTheme.bodyMedium!.inherit;
      expect(themeInherit, isFalse, reason: 'theme styles are inherit: false');

      final Map<String, TextStyle> styles = <String, TextStyle>{
        'title': AuthTextStyles.title(context),
        'subtitle': AuthTextStyles.subtitle(context),
        'fieldLabel': AuthTextStyles.fieldLabel(context),
        'fieldValue': AuthTextStyles.fieldValue(context),
        'fieldHint': AuthTextStyles.fieldHint(context),
        'fieldError': AuthTextStyles.fieldError(context),
        'buttonLabel': AuthTextStyles.buttonLabel(context),
        'footerQuestion': AuthTextStyles.footerQuestion(context),
        'footerAction': AuthTextStyles.footerAction(context),
        'snackBar': AuthTextStyles.snackBar(context),
      };

      for (final MapEntry<String, TextStyle> entry in styles.entries) {
        expect(
          entry.value.inherit,
          themeInherit,
          reason: '${entry.key} must share the theme\'s inherit flag',
        );
        // `InputDecorator` dereferences `labelStyle.textBaseline!`, and an
        // inherit-false style replaces the theme's rather than merging with it —
        // so the baseline has to survive the derivation.
        expect(
          entry.value.textBaseline,
          isNotNull,
          reason: '${entry.key} must carry a textBaseline',
        );
      }
    });
  });
}
