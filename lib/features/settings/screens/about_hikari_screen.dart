// lib/features/settings/screens/about_hikari_screen.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutHikariScreen extends StatefulWidget {
    const AboutHikariScreen({super.key});

    @override
    State<AboutHikariScreen> createState() => _AboutHikariScreenState();
}

class _AboutHikariScreenState extends State<AboutHikariScreen> {
    String _version = '—';

    @override
    void initState() {
        super.initState();
        _load();
    }

    Future<void> _load() async {
        try {
        final info = await PackageInfo.fromPlatform();
        if (!mounted) return;
        setState(() => _version = '${info.version} (${info.buildNumber})');
        } catch (_) {}
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('About Hikari')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    ListTile(
                        title: const Text('Version'),
                        subtitle: Text(_version),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                        'Hikari is a modern, secure money app focused on a clean UX and reliable transfers.',
                    ),
                ],
            ),
        );
    }
}
