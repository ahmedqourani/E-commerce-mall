/// Currency formatting for the whole app.
///
/// Prices used to be interpolated inline — `'$price'`, `'${price} 💵'`,
/// `'\$16.48'` — which gave three different renderings of the same number and
/// showed raw doubles like `9.9` in the cart. Everything routes through here
/// instead.
///
/// Hand-rolled rather than via `intl`, which the project does not depend on.
class Money {
  const Money._();

  /// `1234.5` → `$1,234.50`.
  static String format(num value) {
    final negative = value < 0;
    final fixed = value.abs().toStringAsFixed(2);
    final dot = fixed.indexOf('.');
    final whole = fixed.substring(0, dot);
    final cents = fixed.substring(dot + 1);

    final grouped = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(',');
      grouped.write(whole[i]);
    }

    return '${negative ? '-' : ''}\$$grouped.$cents';
  }

  /// `7.17` → `-7%`. For the discount badge, using the API's own percentage.
  static String discountBadge(double percentage) =>
      '-${percentage.round()}%';
}
