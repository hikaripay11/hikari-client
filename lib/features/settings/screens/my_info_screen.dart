// lib/features/settings/screens/my_info_screen.dart
import 'package:flutter/material.dart';

class MyInfoScreen extends StatefulWidget {
    const MyInfoScreen({super.key});

    @override
    State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
    final _form = GlobalKey<FormState>();
    final _name = TextEditingController(text: 'BJ Choi');
    final _phone = TextEditingController(text: '+33 6 12 34 56 78');
    String _country = 'France';

    @override
    void dispose() {
        _name.dispose();
        _phone.dispose();
        super.dispose();
    }

    void _save() {
        if (_form.currentState?.validate() ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved')),
            );
            // TODO: connect API
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('My Info')),
            body: Form(
                key: _form,
                child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                        Center(
                            child: CircleAvatar(
                                radius: 36,
                                backgroundColor: cs.surfaceContainerHighest,
                                child: const Text('BJ'),
                            ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(labelText: 'Full name'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(labelText: 'Phone number'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                            value: _country,
                            items: const [
                                DropdownMenuItem(value: 'France', child: Text('France')),
                                DropdownMenuItem(value: 'Korea', child: Text('Korea')),
                                DropdownMenuItem(value: 'Japan', child: Text('Japan')),
                            ],
                            onChanged: (v) => setState(() => _country = v!),
                            decoration: const InputDecoration(labelText: 'Country/Region'),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(onPressed: _save, child: const Text('Save')),
                    ],
                ),
            ),
        );
    }
}
