import 'package:e_commerce_mall/core/theme/auth_palette.dart';
import 'package:e_commerce_mall/features/auth/widgets/auth_text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The auth-flow text field: a label above a rounded, light-grey, subtly
/// bordered input.
///
/// Used only by the login and register screens, which is why it reads from
/// [AuthPalette] rather than `context.colors`.
class CustomTextfomfield extends StatefulWidget {
  const CustomTextfomfield({
    super.key,
    required this.hint,
    required this.obsecure,
    required this.controller,
    this.label,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
  });

  /// Placeholder inside the field, e.g. "Enter your email".
  final String hint;

  final bool obsecure;
  final TextEditingController controller;

  /// Rendered above the field, e.g. "Email". Omitted when null.
  final String? label;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextfomfield> createState() => _CustomTextfomfieldState();
}

class _CustomTextfomfieldState extends State<CustomTextfomfield> {
  late bool _obsecure;

  @override
  void initState() {
    super.initState();
    _obsecure = widget.obsecure;
  }

  /// All states share one radius so the field never changes shape.
  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(14),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Every style here is derived from the ambient text theme by
    // [AuthTextStyles], so the field's own styles carry the same `inherit` flag
    // as the ones `InputDecorator` animates against. Mixing a bare
    // `TextStyle(...)` (inherit: true) with a theme-derived one (inherit: false)
    // is what makes `TextStyle.lerp` throw when the field takes focus or fails
    // validation.
    final TextStyle hintStyle = AuthTextStyles.fieldHint(context);
    final TextStyle errorStyle = AuthTextStyles.fieldError(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AuthTextStyles.fieldLabel(context)),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          cursorColor: AuthPalette.accent,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          style: AuthTextStyles.fieldValue(context),
          // Messages appear as soon as a field has been touched and left in a
          // bad state, instead of only on submit.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Preserved fallback: a field with no explicit validator still
          // refuses to be empty, exactly as before.
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please fill ${widget.hint}';
                }
                return null;
              },
          obscureText: _obsecure,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: hintStyle,
            // The label is drawn above the field, not inside the decoration, so
            // there is no floating-label animation here. If a `labelText` is
            // ever added, `labelStyle` and `floatingLabelStyle` must come from
            // the same base — those two are the pair `InputDecorator`
            // interpolates on focus.
            errorStyle: errorStyle,
            fillColor: AuthPalette.field,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: widget.obsecure
                ? IconButton(
                    // Was a bare GestureDetector — an IconButton gets the
                    // ripple, the focus ring and a real tap target, and the
                    // label tells a screen reader what it does.
                    onPressed: () => setState(() => _obsecure = !_obsecure),
                    icon: Icon(
                      _obsecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                      size: 20,
                      color: AuthPalette.textMuted,
                    ),
                    tooltip: _obsecure ? 'Show password' : 'Hide password',
                  )
                : null,
            enabledBorder: _border(AuthPalette.fieldBorder),
            focusedBorder: _border(AuthPalette.accent, width: 1.5),
            errorBorder: _border(AuthPalette.error),
            focusedErrorBorder: _border(AuthPalette.error, width: 1.5),
          ),
        ),
      ],
    );
  }
}
