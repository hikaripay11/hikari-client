// lib/features/settings/screens/transfer_deposit_alerts_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferDepositAlertsScreen extends StatefulWidget {
    const TransferDepositAlertsScreen({super.key});

    @override
    State<TransferDepositAlertsScreen> createState() => _TransferDepositAlertsScreenState();
}

class _TransferDepositAlertsScreenState extends State<TransferDepositAlertsScreen> {
    // Pref keys
    static const _kPush = 'alerts.push';
    static const _kEmail = 'alerts.email';
    static const _kSms = 'alerts.sms';
    static const _kIncoming = 'alerts.incoming';
    static const _kOutgoing = 'alerts.outgoing';
    static const _kFailed = 'alerts.failed';
    static const _kQuietFromH = 'alerts.quiet.from.h';
    static const _kQuietFromM = 'alerts.quiet.from.m';
    static const _kQuietToH = 'alerts.quiet.to.h';
    static const _kQuietToM = 'alerts.quiet.to.m';

    bool _loading = true;
    bool _saving = false;

    bool push = true;
    bool email = false;
    bool sms = false;

    bool incoming = true;
    bool outgoing = true;
    bool failed = true;

    TimeOfDay? quietFrom;
    TimeOfDay? quietTo;

    @override
    void initState() {
        super.initState();
        _load();
    }

    Future<void> _load() async {
        setState(() => _loading = true);
        final p = await SharedPreferences.getInstance();

        setState(() {
            push = p.getBool(_kPush) ?? true;
            email = p.getBool(_kEmail) ?? false;
            sms = p.getBool(_kSms) ?? false;

            incoming = p.getBool(_kIncoming) ?? true;
            outgoing = p.getBool(_kOutgoing) ?? true;
            failed = p.getBool(_kFailed) ?? true;

            final fh = p.getInt(_kQuietFromH);
            final fm = p.getInt(_kQuietFromM);
            final th = p.getInt(_kQuietToH);
            final tm = p.getInt(_kQuietToM);
            if (fh != null && fm != null) quietFrom = TimeOfDay(hour: fh, minute: fm);
            if (th != null && tm != null) quietTo = TimeOfDay(hour: th, minute: tm);

            _loading = false;
        });
    }

    Future<void> _save() async {
        if (!_validateQuiet()) return;

        setState(() => _saving = true);
        final p = await SharedPreferences.getInstance();
        await p.setBool(_kPush, push);
        await p.setBool(_kEmail, email);
        await p.setBool(_kSms, sms);

        await p.setBool(_kIncoming, incoming);
        await p.setBool(_kOutgoing, outgoing);
        await p.setBool(_kFailed, failed);

        if (quietFrom != null && quietTo != null) {
            await p.setInt(_kQuietFromH, quietFrom!.hour);
            await p.setInt(_kQuietFromM, quietFrom!.minute);
            await p.setInt(_kQuietToH, quietTo!.hour);
            await p.setInt(_kQuietToM, quietTo!.minute);
        } else {
            await p.remove(_kQuietFromH);
            await p.remove(_kQuietFromM);
            await p.remove(_kQuietToH);
            await p.remove(_kQuietToM);
        }

        if (!mounted) return;
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }

    Future<void> _reset() async {
        setState(() {
            push = true;
            email = false;
            sms = false;
            incoming = true;
            outgoing = true;
            failed = true;
            quietFrom = null;
            quietTo = null;
        });
        await _save();
    }

    String _quietLabel() {
        if (quietFrom == null || quietTo == null) return 'Off';
        final l = MaterialLocalizations.of(context);
        final f = l.formatTimeOfDay(quietFrom!, alwaysUse24HourFormat: true);
        final t = l.formatTimeOfDay(quietTo!, alwaysUse24HourFormat: true);
        return '$f – $t';
    }

    bool _validateQuiet({bool toastOnError = true}) {
        if (quietFrom == null && quietTo == null) return true;
        if (quietFrom == null || quietTo == null) {
            if (toastOnError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Select both start and end time or turn Off')),
                );
            }
            return false;
        }
        // 동일 시각 금지 (0분 간격)
        if (quietFrom!.hour == quietTo!.hour && quietFrom!.minute == quietTo!.minute) {
            if (toastOnError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quiet hours cannot be 0 minutes')),
                );
            }
            return false;
        }
        return true;
    }

    Future<void> _pick(bool from) async {
        final init = from
            ? (quietFrom ?? const TimeOfDay(hour: 22, minute: 0))
            : (quietTo ?? const TimeOfDay(hour: 7, minute: 0));
        final t = await showTimePicker(context: context, initialTime: init);
        if (t != null) {
            setState(() {
                if (from) {
                    quietFrom = t;
                } else {
                    quietTo = t;
                }
            });
            _validateQuiet(); // 즉시 검증
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        return Scaffold(
        appBar: AppBar(
            title: const Text('Transfer & Deposit Alerts'),
            actions: [
                TextButton(
                    onPressed: _saving ? null : _reset,
                    child: const Text('Reset'),
                ),
                const SizedBox(width: 8),
            ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    // Channels
                    Text('Channels',
                        style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    SwitchListTile(
                        value: push,
                        onChanged: (v) => setState(() => push = v),
                        title: const Text('Push'),
                        subtitle: const Text('App notifications'),
                    ),
                    SwitchListTile(
                        value: email,
                        onChanged: (v) => setState(() => email = v),
                        title: const Text('Email'),
                    ),
                    SwitchListTile(
                        value: sms,
                        onChanged: (v) => setState(() => sms = v),
                        title: const Text('SMS'),
                    ),
                    if (!push && !email && !sms)
                    Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                            'All channels are off — you won’t receive alerts.',
                            style: tt.bodySmall?.copyWith(color: cs.error),
                        ),
                    ),

                    const SizedBox(height: 12),

                    // Events
                    Text('Events',
                        style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    SwitchListTile(
                        value: incoming,
                        onChanged: (v) => setState(() => incoming = v),
                        title: const Text('Incoming transfers'),
                    ),
                    SwitchListTile(
                        value: outgoing,
                        onChanged: (v) => setState(() => outgoing = v),
                        title: const Text('Outgoing transfers'),
                    ),
                    SwitchListTile(
                        value: failed,
                        onChanged: (v) => setState(() => failed = v),
                        title: const Text('Failed / reversed'),
                    ),

                    const SizedBox(height: 12),

                    // Quiet hours
                    Text('Quiet hours',
                        style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    ListTile(
                        title: const Text('Start'),
                        subtitle: Text(quietFrom == null
                            ? 'Off'
                            : MaterialLocalizations.of(context).formatTimeOfDay(
                                quietFrom!, alwaysUse24HourFormat: true)),
                        trailing: const Icon(Icons.schedule),
                        onTap: () => _pick(true),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                        title: const Text('End'),
                        subtitle: Text(quietTo == null
                            ? 'Off'
                            : MaterialLocalizations.of(context).formatTimeOfDay(
                                quietTo!, alwaysUse24HourFormat: true)),
                        trailing: const Icon(Icons.schedule),
                        onTap: () => _pick(false),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    const SizedBox(height: 6),
                    Row(
                        children: [
                            Text('Schedule: ${_quietLabel()}'),
                            const Spacer(),
                            TextButton(
                                onPressed: () => setState(() {
                                    quietFrom = null;
                                    quietTo = null;
                                }),
                                child: const Text('Turn off'),
                            ),
                        ],
                    ),

                    const SizedBox(height: 20),

                    // Save
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
        );
    }
}
