// lib/features/settings/screens/open_source_licenses_screen.dart
import 'package:flutter/material.dart';

class OpenSourceLicensesScreen extends StatelessWidget {
    const OpenSourceLicensesScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Open Source Licenses')),
            body: Center(
                child: FilledButton(
                    onPressed: () {
                        showLicensePage(
                            context: context,
                            applicationName: 'Hikari',
                            applicationVersion: '0.1.0-dev',
                        );
                    },
                    child: const Text('View licenses'),
                ),
            ),
        );
    }
}
