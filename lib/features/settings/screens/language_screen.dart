// lib/features/settings/screens/language_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/settings_controller.dart';
import '../../../core/models/app_settings.dart';

class LanguageScreen extends ConsumerWidget {
    const LanguageScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final state = ref.watch(settingsProvider);
        final notifier = ref.read(settingsProvider.notifier);
        final s = state.value ?? AppSettings.defaultValue;

        // 표시 라벨 ↔ 코드 매핑
        final languages = <String, String>{
            'English': 'en',
            '日本語': 'ja',
            '한국어': 'ko',
            'Français': 'fr', // 원하면 app.dart의 supportedLocales에 Locale('fr') 추가
        };

        final groupCode = s.locale.languageCode;

        void onPick(String code) {
            notifier.setLocale(Locale(code));
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language set to ${_labelForCode(code, languages)}')),
            );
        }

        return Scaffold(
            appBar: AppBar(title: const Text('Language')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    for (final entry in languages.entries)
                        RadioListTile<String>(
                            value: entry.value,
                            groupValue: groupCode,
                            onChanged: (v) => onPick(v!),
                            title: Text(entry.key),
                        ),

                    const SizedBox(height: 12),

                    // 미리보기 문장
                    _PreviewNote(currentCode: groupCode),
                ],
            ),
        );
    }

    String _labelForCode(String code, Map<String, String> map) {
        return map.entries.firstWhere((e) => e.value == code).key;
    }
}

class _PreviewNote extends StatelessWidget {
    final String currentCode;
    const _PreviewNote({required this.currentCode});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        return Container(
            decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
                children: [
                    Icon(Icons.language, color: cs.primary),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                        _sampleFor(currentCode),
                        style: tt.bodyMedium,
                        ),
                    ),
                ],
            ),
        );
    }

    String _sampleFor(String code) {
        switch (code) {
            case 'ja':
                return 'プレビュー: シンプルで安全な送金アプリ。';
            case 'ko':
                return '미리보기: 간편하고 안전한 송금 앱.';
            case 'fr':
                return 'Aperçu : application de virement simple et sécurisée.';
            case 'en':
            default:
                return 'Preview: Simple and secure remittance app.';
        }
    }
}
