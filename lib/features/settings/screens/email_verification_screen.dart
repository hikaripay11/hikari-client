// lib/features/settings/screens/email_verification_screen.dart
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
    const EmailVerificationScreen({super.key});

    @override
    State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
    final _email = TextEditingController(text: 'you@example.com');
    final _code = TextEditingController();
    bool _verified = false;
    bool _sending = false;

    @override
    void dispose() {
        _email.dispose();
        _code.dispose();
        super.dispose();
    }

    Future<void> _sendCode() async {
        setState(() => _sending = true);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => _sending = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent')),
        );
    }

    void _verify() {
        setState(() => _verified = _code.text.trim() == '000000');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_verified ? 'Email verified' : 'Invalid code')),
        );
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Email & Verification')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    TextField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email address'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                        children: [
                            Icon(
                                _verified ? Icons.verified : Icons.error_outline,
                                color: _verified ? cs.primary : cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(_verified ? 'Verified' : 'Not verified'),
                            const Spacer(),
                            TextButton.icon(
                                onPressed: _sending ? null : _sendCode,
                                icon: _sending
                                    ? const SizedBox(
                                        width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.email_outlined),
                                label: const Text('Send code'),
                            ),
                        ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                        controller: _code,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Enter 6-digit code'),
                        maxLength: 6,
                    ),
                    FilledButton(onPressed: _verify, child: const Text('Verify')),
                ],
            ),
        );
    }
}
