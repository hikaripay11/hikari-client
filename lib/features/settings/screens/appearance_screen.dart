// lib/features/settings/screens/appearance_screen.dart
import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
    const AppearanceScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Appearance')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    ListTile(
                        title: const Text('Theme'),
                        subtitle: const Text('Light only (Dark mode planned)'),
                        trailing: const Icon(Icons.lock_outline),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        'We\'re polishing a delightful light theme for Hikari. Dark mode is on the roadmap.',
                        style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
            ),
        );
    }
}
