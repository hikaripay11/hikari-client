// lib/features/settings/screens/privacy_terms_screen.dart
import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
    const PrivacyTermsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Privacy & Terms')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    ListTile(
                        title: const Text('Privacy Policy'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                            // TODO: open in-app markdown / webview
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Open Privacy Policy (TBD)')),
                            );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                        title: const Text('Terms of Service'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                            // TODO: open in-app markdown / webview
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Open Terms of Service (TBD)')),
                            );
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    ),
                ],
            ),
        );
    }
}
