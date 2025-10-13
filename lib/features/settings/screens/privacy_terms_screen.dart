import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
    const PrivacyTermsScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Privacy & Terms')),
            body: const Center(child: Text('Privacy Policy & Terms of Service (TBD)')),
        );
    }
}
