// lib/features/settings/screens/my_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    bool _saving = false;
    bool _dirty = false;

    // 간단 국가 코드 매핑 (필요 시 확장)
    static const _countryDial = <String, String>{
        'France': '+33',
        'Korea': '+82',
        'Japan': '+81',
    };

    @override
    void initState() {
        super.initState();
        _name.addListener(_markDirty);
        _phone.addListener(_markDirty);
    }

    @override
    void dispose() {
        _name.removeListener(_markDirty);
        _phone.removeListener(_markDirty);
        _name.dispose();
        _phone.dispose();
        super.dispose();
    }

    void _markDirty() => setState(() => _dirty = true);

    String _initialsFrom(String full) {
        final parts = full.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
        if (parts.isEmpty) return '??';
        if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
        final first = parts.first.characters.first.toUpperCase();
        final last = parts.last.characters.first.toUpperCase();
        return '$first$last';
    }

    String? _validateName(String? v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        if (v.trim().length < 2) return 'Too short';
        return null;
    }

    String? _validatePhone(String? v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        final raw = v.replaceAll(RegExp(r'[\s\-]'), '');
        // 허용: +숫자, 최소 7~최대 15자리 (E.164 근사)
        final ok = RegExp(r'^\+?[0-9]{7,15}$').hasMatch(raw);
        if (!ok) return 'Enter a valid phone number';
        // 선택한 국가 코드 권장 체크(강제는 아님)
        final dial = _countryDial[_country];
        if (dial != null && !raw.startsWith(dial.replaceAll(' ', '').replaceAll('-', ''))) {
            return 'Should start with ${_countryDial[_country]}';
        }
        return null;
    }

    Future<bool> _confirmLeaveIfDirty() async {
        if (!_dirty || _saving) return true;
        final yes = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
                title: const Text('Discard changes?'),
                content: const Text('You have unsaved changes. Leave without saving?'),
                actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Discard')),
                ],
            ),
        );
        return yes ?? false;
    }

    Future<void> _save() async {
        final valid = _form.currentState?.validate() ?? false;
        if (!valid) return;

        setState(() => _saving = true);
        try {
            // TODO: connect API
            // await profileRepository.update(name: _name.text.trim(), phone: _phone.text.trim(), country: _country);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
            setState(() => _dirty = false);
            Navigator.of(context).maybePop();
        } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to save: $e')),
            );
        } finally {
            if (mounted) setState(() => _saving = false);
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        return WillPopScope(
            onWillPop: _confirmLeaveIfDirty,
            child: Scaffold(
                appBar: AppBar(
                    title: const Text('My Info'),
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () async {
                            if (await _confirmLeaveIfDirty()) Navigator.of(context).maybePop();
                        },
                    ),
                ),
                body: Form(
                    key: _form,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                            // Avatar + edit
                            Center(
                                child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                        CircleAvatar(
                                            radius: 36,
                                            backgroundColor: cs.surfaceContainerHighest,
                                            child: Text(
                                                _initialsFrom(_name.text),
                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                                            ),
                                        ),
                                        Positioned(
                                            right: -2,
                                            bottom: -2,
                                            child: Material(
                                                color: cs.surface,
                                                shape: const CircleBorder(),
                                                child: IconButton(
                                                    tooltip: 'Change photo',
                                                    iconSize: 20,
                                                    onPressed: () {
                                                        // TODO: image picker 연결
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text('Photo picker (TBD)')),
                                                        );
                                                    },
                                                    icon: const Icon(Icons.edit),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),

                            const SizedBox(height: 16),

                            // Name
                            TextFormField(
                                controller: _name,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.name],
                                decoration: const InputDecoration(labelText: 'Full name'),
                                validator: _validateName,
                            ),
                            const SizedBox(height: 12),

                            // Phone
                            TextFormField(
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.telephoneNumber],
                                inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
                                    LengthLimitingTextInputFormatter(20),
                                ],
                                decoration: InputDecoration(
                                    labelText: 'Phone number',
                                    hintText: _countryDial[_country] != null
                                        ? '${_countryDial[_country]} …'
                                        : 'e.g. +33123456789',
                                ),
                                validator: _validatePhone,
                                onFieldSubmitted: (_) => _save(),
                            ),
                            const SizedBox(height: 12),

                            // Country
                            DropdownButtonFormField<String>(
                                value: _country,
                                items: const [
                                    DropdownMenuItem(value: 'France', child: Text('France')),
                                    DropdownMenuItem(value: 'Korea', child: Text('Korea')),
                                    DropdownMenuItem(value: 'Japan', child: Text('Japan')),
                                ],
                                onChanged: (v) {
                                    if (v == null) return;
                                    setState(() {
                                        _country = v;
                                        _dirty = true;
                                    });
                                },
                                decoration: const InputDecoration(labelText: 'Country/Region'),
                            ),

                            const SizedBox(height: 20),

                            FilledButton.icon(
                                onPressed: _saving ? null : _save,
                                icon: _saving
                                    ? const SizedBox(
                                        width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.save),
                                label: const Text('Save'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
