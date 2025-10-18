// lib/core/models/app_settings.dart
import 'package:flutter/material.dart';

class AppSettings {
    final bool notificationsEnabled;
    final Locale locale;
    final double textScale;

    const AppSettings({
        required this.notificationsEnabled,
        required this.locale,
        required this.textScale,
    });

    AppSettings copyWith({
        bool? notificationsEnabled,
        Locale? locale,
        double? textScale,
    }) =>
        AppSettings(
            notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
            locale: locale ?? this.locale,
            textScale: textScale ?? this.textScale,
        );

    static const defaultValue = AppSettings(
        notificationsEnabled: true,
        locale: Locale('en'),
        textScale: 1.0,
    );
}
