import 'dart:math' as math;

import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared shell for the auth screens.
///
/// Owns three things both screens need identically: the cream canvas, the
/// status-bar treatment (the app sets light glyphs globally for its near-black
/// pages — on cream they have to flip to dark, and flip back on their own when
/// this route is popped), and a layout that centres on tall screens, scrolls on
/// short ones and stops widening on tablets.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.children});

  final List<Widget> children;

  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 28,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AuthPalette.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AuthPalette.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: _padding,
                child: ConstrainedBox(
                  // Fill the viewport so the content centres, but let it grow
                  // past it and scroll when the keyboard is up or the screen is
                  // small.
                  constraints: BoxConstraints(
                    minHeight: math.max(
                      0,
                      constraints.maxHeight - _padding.vertical,
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
