// lib/features/settings/screens/language_screen.dart
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
    String _current = 'English';
    final _items = const ['English', '日本語', '한국어', 'Français'];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Language')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    for (final lang in _items)
                        RadioListTile<String>(
                            value: lang,
                            groupValue: _current,
                            onChanged: (v) => setState(() => _current = v!),
                            title: Text(lang),
                        ),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: () {
                            // TODO: persist + force reassemble/localization reload
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Language set to $_current')),
                            );
                        },
                        child: const Text('Save'),
                    ),
                ],
            ),
        );
    }
}
