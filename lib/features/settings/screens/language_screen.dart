import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
    const LanguageScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Language')),
            body: const Center(child: Text('App language picker (EN / 日本語 / KO / FR)')),
        );
    }
}
