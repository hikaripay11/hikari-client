// lib/features/settings/screens/manage_storage_screen.dart
import 'package:flutter/material.dart';

class ManageStorageScreen extends StatefulWidget {
    const ManageStorageScreen({super.key});

    @override
    State<ManageStorageScreen> createState() => _ManageStorageScreenState();
}

class _ManageStorageScreenState extends State<ManageStorageScreen> {
    double _cacheMb = 256;
    bool _wifiOnly = true;
    bool _autoDownloadStatements = true;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Manage Storage')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    Text('Cache size', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    Slider(
                        value: _cacheMb,
                        min: 64,
                        max: 1024,
                        divisions: 15,
                        label: '${_cacheMb.round()} MB',
                        onChanged: (v) => setState(() => _cacheMb = v),
                    ),
                    SwitchListTile(
                        value: _wifiOnly,
                        onChanged: (v) => setState(() => _wifiOnly = v),
                        title: const Text('Download on Wi-Fi only'),
                    ),
                    SwitchListTile(
                        value: _autoDownloadStatements,
                        onChanged: (v) => setState(() => _autoDownloadStatements = v),
                        title: const Text('Auto-download monthly statements'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                        onPressed: () {
                            // TODO: clear cache
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
                        },
                        child: const Text('Clear cache'),
                    ),
                ],
            ),
        );
    }
}
