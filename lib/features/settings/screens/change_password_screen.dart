// lib/features/settings/screens/change_password_screen.dart
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
    const ChangePasswordScreen({super.key});

    @override
    State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
    final _form = GlobalKey<FormState>();
    final _current = TextEditingController();
    final _next = TextEditingController();
    final _confirm = TextEditingController();
    bool _show = false;

    @override
    void dispose() {
        _current.dispose();
        _next.dispose();
        _confirm.dispose();
        super.dispose();
    }

    void _submit() {
        if (!(_form.currentState?.validate() ?? false)) return;
        // TODO: API connect
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed')),
        );
    }

    @override
    Widget build(BuildContext context) {
        final ob = !_show;
        return Scaffold(
            appBar: AppBar(title: const Text('Change Password')),
            body: Form(
                key: _form,
                child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                        TextFormField(
                            controller: _current,
                            obscureText: ob,
                            decoration: const InputDecoration(labelText: 'Current password'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _next,
                            obscureText: ob,
                            decoration: const InputDecoration(labelText: 'New password'),
                            validator: (v) {
                                if (v == null || v.length < 8) return 'At least 8 characters';
                                if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include a number';
                                return null;
                            },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _confirm,
                            obscureText: ob,
                            decoration: InputDecoration(
                                labelText: 'Confirm new password',
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() => _show = !_show),
                                    icon: Icon(_show ? Icons.visibility_off : Icons.visibility),
                                ),
                            ),
                            validator: (v) => v != _next.text ? 'Passwords do not match' : null,
                        ),
                        const SizedBox(height: 20),
                        FilledButton(onPressed: _submit, child: const Text('Update password')),
                    ],
                ),
            ),
        );
    }
}
