import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData hikariTheme(Brightness brightness) {
    final light = ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
            seedColor: HikariColors.primary,
            brightness: Brightness.light,
            primary: HikariColors.primary,
        ),
        scaffoldBackgroundColor: HikariColors.surfaceLight,
        fontFamily: 'SF Pro Display',
    );

    final dark = ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
            seedColor: HikariColors.primary,
            brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: HikariColors.surfaceDark,
    );

    return brightness == Brightness.dark ? dark : light;
}
