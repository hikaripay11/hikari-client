import 'package:flutter/material.dart';

class OpenSourceLicensesScreen extends StatelessWidget {
    const OpenSourceLicensesScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Open Source Licenses')),
            body: const Center(child: Text('License list (TBD)')),
        );
    }
}
