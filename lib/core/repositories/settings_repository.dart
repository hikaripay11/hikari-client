// lib/core/repositories/settings_repository.dart
import 'package:flutter/material.dart';
import '../models/app_settings.dart';

abstract class SettingsRepository {
    Future<AppSettings> load();
    Future<void> setNotifications(bool enabled);
    Future<void> setLocale(Locale locale);
    Future<void> setTextScale(double scale);
}
