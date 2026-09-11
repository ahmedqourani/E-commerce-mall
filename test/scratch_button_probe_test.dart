import 'package:e_commerce_mall/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A button whose own `ButtonStyle.textStyle` is present on some frames and
/// absent on others. When it is absent, `ButtonStyleButton` falls back to
/// `elevatedButtonTheme`'s `_buttonLabel` — a hand-written literal, so
/// `inherit: true`. When it is present, it is theme-derived, so `inherit: false`.
/// `Material` feeds whichever one it gets into `AnimatedDefaultTextStyle`
/// (material.dart:477), which lerps across the change.
class _Flipper extends StatefulWidget {
  const _Flipper();

  @override
  State<_Flipper> createState() => _FlipperState();
}

class _FlipperState extends State<_Flipper> {
  bool themed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: themed
              ? ButtonStyle(
                  textStyle: WidgetStatePropertyAll(
                    Theme.of(context).textTheme.labelLarge,
                  ),
                )
              : null,
          onPressed: () => setState(() => themed = !themed),
          child: const Text('Login'),
        ),
      ],
    );
  }
}

void main() {
  testWidgets('REPRO: literal theme style vs theme-derived style', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: _Flipper()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 40));

    final Object? error = tester.takeException();
    debugPrint('--- caught: $error');
    expect(error, isNotNull, reason: 'the assertion should fire here');
  });
}
