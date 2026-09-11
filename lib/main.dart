import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/core/theme/app_theme.dart';
import 'package:e_commerce_mall/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:e_commerce_mall/cubit/theme_cubit/theme_cubit.dart';
import 'package:e_commerce_mall/cubit/theme_cubit/theme_state.dart';
import 'package:e_commerce_mall/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final tokens = AppColorTokens.light;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: tokens.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => FavoriteCubit()..loadFavorites(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.isDark
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const SplashView(),
        );
      },
    );
  }
}