import 'package:e_commerce_mall/cubit/theme_cubit/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  /// Light is the app's designed appearance — the whole identity is derived from
  /// the warm cream-and-orange login and register screens. The near-black
  /// monochrome system is still fully defined in `AppColorTokens.dark`, so
  /// [changeTheme] remains a working switch between the two.
  ThemeCubit() : super(ThemeState(isDark: false));
  changeTheme(bool isDark) {
    emit(ThemeState(isDark: isDark));
  }
}
