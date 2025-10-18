// lib/features/settings/controllers/settings_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/repositories/settings_repository.dart';
import '../../../core/repositories/settings_repository_prefs.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
    return SettingsRepositoryPrefs();
});

final settingsProvider =
    NotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AsyncValue<AppSettings>> {
    late final SettingsRepository _repo;

    @override
    AsyncValue<AppSettings> build() {
        _repo = ref.read(settingsRepositoryProvider);
        _load();
        return const AsyncValue.loading();
    }

    Future<void> _load() async {
        try {
            final s = await _repo.load();
            state = AsyncValue.data(s);
        } catch (e, st) {
            state = AsyncValue.error(e, st);
        }
    }

    Future<void> setNotifications(bool enabled) async {
        final current = state.value ?? AppSettings.defaultValue;
        state = AsyncValue.data(current.copyWith(notificationsEnabled: enabled));
        await _repo.setNotifications(enabled);
    }

    Future<void> setLocale(Locale locale) async {
        final current = state.value ?? AppSettings.defaultValue;
        state = AsyncValue.data(current.copyWith(locale: locale));
        await _repo.setLocale(locale);
    }

    Future<void> setTextScale(double scale) async {
        final current = state.value ?? AppSettings.defaultValue;
        state = AsyncValue.data(current.copyWith(textScale: scale));
        await _repo.setTextScale(scale);
    }
}
