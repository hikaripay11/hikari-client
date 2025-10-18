// lib/features/settings/screens/appearance_screen.dart
import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
    const AppearanceScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
            appBar: AppBar(title: const Text('Appearance')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    // Theme (read-only for now)
                    ListTile(
                        title: const Text('Theme'),
                        subtitle: const Text('Light only (Dark mode planned)'),
                        trailing: const Icon(Icons.lock_outline),
                        onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Dark mode is planned — stay tuned!')),
                            );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    ),

                    const SizedBox(height: 12),

                    // Tiny theme preview
                    const _PreviewCard(title: 'Preview', child: const _ThemePreview()),

                    const SizedBox(height: 12),

                    // Copy
                    Text(
                        "We're polishing a delightful light theme for Hikari. "
                        "Dark mode is on the roadmap and will arrive after core money features.",
                        style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 8),
                    Text(
                        'Tip: Text size can be adjusted in Settings → Display & Theme → Text Size.',
                        style: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                ],
            ),
        );
    }
}

class _PreviewCard extends StatelessWidget {
    final String title;
    final Widget child;
    const _PreviewCard({required this.title, required this.child});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        return Container(
            decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(title,
                        style: textTheme.labelLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 8),
                    child,
                ],
            ),
        );
    }
}

class _ThemePreview extends StatelessWidget {
    const _ThemePreview();

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        return Container(
            height: 80,
            decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
                children: [
                    // Icon chip
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sunny, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            'Light theme in action — cards, borders, and subtle surfaces.',
                            style: textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                        ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.check_circle, color: cs.primary),
                ],
            ),
        );
    }
}
