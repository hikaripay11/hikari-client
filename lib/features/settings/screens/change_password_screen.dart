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

    bool _showCurrent = false;
    bool _showNext = false;
    bool _showConfirm = false;
    bool _loading = false;

    // 실시간 강도 측정 값 (0.0 ~ 1.0)
    double _strength = 0.0;
    String _strengthLabel = 'Too weak';

    @override
    void initState() {
        super.initState();
        _next.addListener(_recalcStrength);
    }

    @override
    void dispose() {
        _current.dispose();
        _next.removeListener(_recalcStrength);
        _next.dispose();
        _confirm.dispose();
        super.dispose();
    }

    // 간단한 강도 계산기 (길이 + 문자군 다양성)
    void _recalcStrength() {
        final v = _next.text;
        final lengthScore = (v.length >= 12)
            ? 1.0
            : (v.length >= 10)
                ? 0.75
                : (v.length >= 8)
                    ? 0.5
                    : (v.isNotEmpty ? 0.25 : 0.0);

        int classes = 0;
        if (RegExp(r'[a-z]').hasMatch(v)) classes++;
        if (RegExp(r'[A-Z]').hasMatch(v)) classes++;
        if (RegExp(r'[0-9]').hasMatch(v)) classes++;
        if (RegExp(r'[^\w\s]').hasMatch(v)) classes++;

        final classScore = (classes / 4);
        final score = (lengthScore * 0.6) + (classScore * 0.4);

        String label;
        if (score >= 0.85) {
            label = 'Strong';
        } else if (score >= 0.65) {
            label = 'Good';
        } else if (score >= 0.45) {
            label = 'Fair';
        } else if (score > 0.0) {
            label = 'Weak';
        } else {
            label = 'Too weak';
        }

        setState(() {
            _strength = score.clamp(0.0, 1.0);
            _strengthLabel = label;
        });
    }

    String? _validateCurrent(String? v) {
        if (v == null || v.isEmpty) return 'Required';
        return null;
    }

    String? _validateNew(String? v) {
        if (v == null || v.isEmpty) return 'Required';
        if (v.length < 8) return 'At least 8 characters';
        if (!RegExp(r'[A-Za-z]').hasMatch(v)) return 'Include at least one letter';
        if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number';
        // 특수문자 권장 (필수는 아님) — 정책 바뀌면 필수로 바꿔도 됨
        if (v == _current.text) return 'New password must be different from current';
        return null;
    }

    String? _validateConfirm(String? v) {
        if (v == null || v.isEmpty) return 'Required';
        if (v != _next.text) return 'Passwords do not match';
        return null;
    }

    Future<void> _submit() async {
        final valid = _form.currentState?.validate() ?? false;
        if (!valid) return;

        setState(() => _loading = true);
        try {
            // TODO: API connect (hikari-gateway)
            // 예: await authRepository.changePassword(_current.text, _next.text);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed')),
            );
            Navigator.of(context).maybePop();
        } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to change password: $e')),
            );
        } finally {
            if (mounted) setState(() => _loading = false);
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
            appBar: AppBar(title: const Text('Change Password')),
            body: Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                        // Current
                        TextFormField(
                            controller: _current,
                            obscureText: !_showCurrent,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'Current password',
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() => _showCurrent = !_showCurrent),
                                    icon: Icon(_showCurrent ? Icons.visibility_off : Icons.visibility),
                                ),
                            ),
                            validator: _validateCurrent,
                        ),
                        const SizedBox(height: 12),

                        // New
                        TextFormField(
                            controller: _next,
                            obscureText: !_showNext,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: 'New password',
                                helperText: 'Use 8+ chars with letters and numbers',
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() => _showNext = !_showNext),
                                    icon: Icon(_showNext ? Icons.visibility_off : Icons.visibility),
                                ),
                            ),
                            validator: _validateNew,
                        ),

                        // Strength meter
                        if (_next.text.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _StrengthBar(value: _strength, label: _strengthLabel),
                        ],

                        const SizedBox(height: 12),

                        // Confirm
                        TextFormField(
                            controller: _confirm,
                            obscureText: !_showConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                                labelText: 'Confirm new password',
                                suffixIcon: IconButton(
                                    onPressed: () => setState(() => _showConfirm = !_showConfirm),
                                    icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility),
                                ),
                            ),
                            validator: _validateConfirm,
                        ),

                        const SizedBox(height: 20),

                        FilledButton.icon(
                            onPressed: _loading ? null : _submit,
                            icon: _loading
                                ? const SizedBox(
                                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.check),
                            label: const Text('Update password'),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _StrengthBar extends StatelessWidget {
    final double value;
    final String label;
    const _StrengthBar({required this.value, required this.label});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        Color barColor;

        if (value >= 0.85) {
            barColor = Colors.green;
        } else if (value >= 0.65) {
            barColor = Colors.lightGreen;
        } else if (value >= 0.45) {
            barColor = Colors.orange;
        } else {
            barColor = Colors.redAccent;
        }

        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                color: cs.surfaceContainerLowest,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
                children: [
                    Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                                value: value.clamp(0.0, 1.0),
                                minHeight: 8,
                                color: barColor,
                                backgroundColor: cs.surfaceContainerHigh,
                            ),
                        ),
                    ),
                    const SizedBox(width: 12),
                    Text(label, style: Theme.of(context).textTheme.labelMedium),
                ],
            ),
        );
    }
}
