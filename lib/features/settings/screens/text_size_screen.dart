// lib/features/settings/screens/text_size_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/settings_controller.dart';
import '../../../core/models/app_settings.dart';

class TextSizeScreen extends ConsumerWidget {
    const TextSizeScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final state = ref.watch(settingsProvider);
        final notifier = ref.read(settingsProvider.notifier);
        final s = state.value ?? AppSettings.defaultValue;

        // 0.85 ~ 1.30 사이에서 소수 2자리 → 소수 1자리로 정리
        void onSlide(double v) {
            final fixed = double.parse(v.toStringAsFixed(2));
            notifier.setTextScale(fixed);
        }

        return Scaffold(
            appBar: AppBar(title: const Text('Text Size')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    // 현재 배율 표시
                    Row(
                        children: [
                            Text('Current: ${(s.textScale * 100).round()}%'),
                            const Spacer(),
                            TextButton(
                                onPressed: s.textScale == 1.0 ? null : () => notifier.setTextScale(1.0),
                                child: const Text('Reset to 100%'),
                            ),
                        ],
                    ),

                    Slider(
                        value: s.textScale.clamp(0.85, 1.30),
                        onChanged: onSlide,
                        min: 0.85,
                        max: 1.30,
                        divisions: 9, // 0.05 간격
                        label: '${(s.textScale * 100).round()}%',
                    ),

                    const SizedBox(height: 12),

                    // 간단 프리셋
                    Wrap(
                        spacing: 8,
                        children: [
                            _PresetChip(label: '90%', value: 0.90, current: s.textScale, onPick: notifier.setTextScale),
                            _PresetChip(label: '100%', value: 1.00, current: s.textScale, onPick: notifier.setTextScale),
                            _PresetChip(label: '110%', value: 1.10, current: s.textScale, onPick: notifier.setTextScale),
                            _PresetChip(label: '120%', value: 1.20, current: s.textScale, onPick: notifier.setTextScale),
                            _PresetChip(label: '130%', value: 1.30, current: s.textScale, onPick: notifier.setTextScale),
                        ],
                    ),

                    const SizedBox(height: 16),

                    // 미리보기: 전역 스케일이 이미 적용되지만, 화면 내에서 다시 한 번 예시를 보여줌
                    const _PreviewCard(
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                                Text(
                                    'Preview — Headline',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 6),
                                Text('Preview — Body: The quick brown fox jumps over the lazy dog. 123,456.78 ¥€₩'),
                                SizedBox(height: 6),
                                Text('プレビュー — 本文: シンプルで安全な送金アプリです。'),
                                SizedBox(height: 6),
                                Text('미리보기 — 본문: 간편하고 안전한 송금 앱입니다.'),
                            ],
                        ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                        'Tip: Text size applies across the entire app immediately.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                ],
            ),
        );
    }
}

class _PresetChip extends StatelessWidget {
    const _PresetChip({
        required this.label,
        required this.value,
        required this.current,
        required this.onPick,
    });

    final String label;
    final double value;
    final double current;
    final void Function(double) onPick;

    @override
    Widget build(BuildContext context) {
        final selected = (current - value).abs() < 0.001;
        return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onPick(value),
        );
    }
}

class _PreviewCard extends StatelessWidget {
    const _PreviewCard({required this.child});
    final Widget child;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Container(
            decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.all(12),
            child: child,
        );
    }
}
