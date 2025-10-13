// lib/features/settings/screens/transfer_deposit_alerts_screen.dart
import 'package:flutter/material.dart';

class TransferDepositAlertsScreen extends StatefulWidget {
    const TransferDepositAlertsScreen({super.key});

    @override
    State<TransferDepositAlertsScreen> createState() => _TransferDepositAlertsScreenState();
}

class _TransferDepositAlertsScreenState extends State<TransferDepositAlertsScreen> {
    bool push = true;
    bool email = false;
    bool sms = false;

    bool incoming = true;
    bool outgoing = true;
    bool failed = true;

    TimeOfDay? quietFrom;
    TimeOfDay? quietTo;

    Future<void> _pick(bool from) async {
        final init = from ? const TimeOfDay(hour: 22, minute: 0) : const TimeOfDay(hour: 7, minute: 0);
        final t = await showTimePicker(context: context, initialTime: init);
        if (t != null) setState(() => from ? quietFrom = t : quietTo = t);
    }

    String _quietLabel() {
        if (quietFrom == null || quietTo == null) return 'Off';
        String f(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
        return '${f(quietFrom!)}–${f(quietTo!)}';
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: const Text('Transfer & Deposit Alerts')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    Text('Channels', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    SwitchListTile(value: push, onChanged: (v) => setState(() => push = v), title: const Text('Push')),
                    SwitchListTile(value: email, onChanged: (v) => setState(() => email = v), title: const Text('Email')),
                    SwitchListTile(value: sms, onChanged: (v) => setState(() => sms = v), title: const Text('SMS')),

                    const SizedBox(height: 12),
                    Text('Events', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    SwitchListTile(value: incoming, onChanged: (v) => setState(() => incoming = v), title: const Text('Incoming transfers')),
                    SwitchListTile(value: outgoing, onChanged: (v) => setState(() => outgoing = v), title: const Text('Outgoing transfers')),
                    SwitchListTile(value: failed, onChanged: (v) => setState(() => failed = v), title: const Text('Failed / reversed')),

                    const SizedBox(height: 12),
                    Text('Quiet hours', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: cs.onSurfaceVariant)),
                    ListTile(
                        title: const Text('Schedule'),
                        subtitle: Text(_quietLabel()),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async { await _pick(true); if (mounted) await _pick(false); },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    ),
                ],
            ),
        );
    }
}
