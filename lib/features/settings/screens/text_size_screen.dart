import 'package:flutter/material.dart';

class TextSizeScreen extends StatelessWidget {
    const TextSizeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Text Size')),
            body: const Center(child: Text('System/App font scaling (TBD)')),
        );
    }
}
