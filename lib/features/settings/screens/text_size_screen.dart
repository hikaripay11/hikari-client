// lib/features/settings/screens/text_size_screen.dart
import 'package:flutter/material.dart';

class TextSizeScreen extends StatefulWidget {
    const TextSizeScreen({super.key});

    @override
    State<TextSizeScreen> createState() => _TextSizeScreenState();
}

class _TextSizeScreenState extends State<TextSizeScreen> {
    double _scale = 1.0; // 0.85 ~ 1.3

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Text Size')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    Slider(
                        value: _scale,
                        onChanged: (v) => setState(() => _scale = v),
                        min: 0.85,
                        max: 1.30,
                        divisions: 9,
                        label: '${(_scale * 100).round()}%',
                    ),
                    const SizedBox(height: 12),
                    MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: _scale),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                                Text('Preview — Headline', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                SizedBox(height: 6),
                                Text('Preview — Body text: The quick brown fox jumps over the lazy dog. 123,456.78 ¥€₩'),
                            ],
                        ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(onPressed: () {
                        // TODO: persist to settings
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
                    }, child: const Text('Save')),
                ],
            ),
        );
    }
}
