// lib/core/repositories/settings_repository_prefs.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import 'settings_repository.dart';

class SettingsRepositoryPrefs implements SettingsRepository {
    static const _kNotif = 'settings.notifications';
    static const _kLang  = 'settings.lang';
    static const _kScale = 'settings.textscale';

    Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

    @override
    Future<AppSettings> load() async {
        final p = await _prefs;
        final notif = p.getBool(_kNotif) ?? AppSettings.defaultValue.notificationsEnabled;
        final lang  = p.getString(_kLang) ?? AppSettings.defaultValue.locale.languageCode;
        final scale = p.getDouble(_kScale) ?? AppSettings.defaultValue.textScale;
        return AppSettings(
            notificationsEnabled: notif,
            locale: Locale(lang),
            textScale: scale,
        );
    }

    @override
    Future<void> setNotifications(bool enabled) async {
        final p = await _prefs;
        await p.setBool(_kNotif, enabled);
    }

    @override
    Future<void> setLocale(Locale locale) async {
        final p = await _prefs;
        await p.setString(_kLang, locale.languageCode);
    }

    @override
    Future<void> setTextScale(double scale) async {
        final p = await _prefs;
        await p.setDouble(_kScale, scale);
    }
}
