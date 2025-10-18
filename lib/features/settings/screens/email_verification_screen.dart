// lib/features/settings/screens/email_verification_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailVerificationScreen extends StatefulWidget {
    const EmailVerificationScreen({super.key});

    @override
    State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
    final _formKey = GlobalKey<FormState>();
    final _email = TextEditingController(text: 'you@example.com');
    final _code = TextEditingController();

    bool _verified = false;
    bool _sending = false;
    bool _verifying = false;

    // 재전송 타이머
    static const _cooldown = 60; // seconds
    int _remain = 0;
    Timer? _timer;

    @override
    void dispose() {
        _timer?.cancel();
        _email.dispose();
        _code.dispose();
        super.dispose();
    }

    bool get _canResend => _remain == 0 && !_sending;
    bool get _canVerify => _code.text.trim().length == 6 && !_verifying;

    String? _validateEmail(String? v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        final email = v.trim();
        final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
        if (!ok) return 'Enter a valid email';
        return null;
    }

    Future<void> _sendCode() async {
        // 이메일 먼저 검사
        if (!(_formKey.currentState?.validate() ?? false)) return;
        setState(() => _sending = true);

        try {
            // TODO: hikari-gateway API: requestEmailVerificationCode(_email.text.trim())
            await Future.delayed(const Duration(milliseconds: 900));
            if (!mounted) return;

            // 타이머 시작
            _startCooldown();
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification email sent')),
            );
        } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to send email: $e')),
            );
        } finally {
            if (mounted) setState(() => _sending = false);
        }
    }

    void _startCooldown() {
        _timer?.cancel();
        setState(() => _remain = _cooldown);
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
            if (!mounted) return;
            if (_remain <= 1) {
                t.cancel();
                setState(() => _remain = 0);
            } else {
                setState(() => _remain -= 1);
            }
        });
    }

    Future<void> _verify() async {
        FocusScope.of(context).unfocus();
        if (!_canVerify) return;

        setState(() => _verifying = true);
        try {
            // TODO: hikari-gateway API: verifyEmailCode(_email.text.trim(), _code.text.trim())
            await Future.delayed(const Duration(milliseconds: 600));
            final ok = _code.text.trim() == '000000'; // 더미
            if (!mounted) return;

            setState(() => _verified = ok);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ok ? 'Email verified' : 'Invalid code')),
            );
        } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Verification failed: $e')),
            );
        } finally {
            if (mounted) setState(() => _verifying = false);
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        return Scaffold(
            appBar: AppBar(title: const Text('Email & Verification')),
            body: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                        // Email
                        TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.email],
                            validator: _validateEmail,
                            decoration: const InputDecoration(
                                labelText: 'Email address',
                                hintText: 'name@example.com',
                            ),
                            onChanged: (_) {
                                // 이메일 바꾸면 검증 상태 초기화
                                if (_verified) setState(() => _verified = false);
                            },
                        ),
                        const SizedBox(height: 8),

                        // Status + send code
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
                                    onPressed: _canResend ? _sendCode : null,
                                    icon: _sending
                                        ? const SizedBox(
                                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                        : const Icon(Icons.email_outlined),
                                    label: Text(
                                        _remain == 0 ? 'Send code' : 'Resend in $_remain s',
                                    ),
                                ),
                            ],
                        ),

                        const SizedBox(height: 16),

                        // Code
                        TextField(
                            controller: _code,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Enter 6-digit code',
                                counterText: '', // maxLength 카운터 숨김
                            ),
                            maxLength: 6,
                            onChanged: (_) => setState(() {}), // 버튼 활성화 갱신
                        ),

                        const SizedBox(height: 8),
                        if (!_verified)
                        Text(
                            'Tip: Check your spam folder if the email doesn’t arrive.',
                            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                        ),

                        const SizedBox(height: 20),

                        FilledButton.icon(
                            onPressed: _canVerify ? _verify : null,
                            icon: _verifying
                                ? const SizedBox(
                                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.verified),
                            label: const Text('Verify'),
                        ),
                    ],
                ),
            ),
        );
    }
}
