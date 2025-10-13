import 'package:flutter/material.dart';

class MyInfoScreen extends StatelessWidget {
    const MyInfoScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('My Info')),
            body: const Center(child: Text('Profile, phone, linked banks (TBD)')),
        );
    }
}
