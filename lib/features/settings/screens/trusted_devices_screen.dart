// lib/features/settings/screens/trusted_devices_screen.dart
import 'package:flutter/material.dart';

class TrustedDevicesScreen extends StatefulWidget {
  const TrustedDevicesScreen({super.key});

  @override
  State<TrustedDevicesScreen> createState() => _TrustedDevicesScreenState();
}

class _TrustedDevicesScreenState extends State<TrustedDevicesScreen> {
    final List<_Device> _devices = [
        _Device('iPhone 16', 'Paris, FR', 'Active now'),
        _Device('MacBook Pro', 'Versailles, FR', 'Last seen 2h ago'),
        _Device('iPad', 'Seoul, KR', 'Last seen 5d ago'),
    ];

    void _revoke(int i) {
        final removed = _devices.removeAt(i);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logged out: ${removed.name}')),
        );
    }

    void _logoutAll() {
        _devices.clear();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out of all devices')),
        );
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(
                title: const Text('Trusted Devices'),
                actions: [
                if (_devices.isNotEmpty)
                    TextButton(
                        onPressed: _logoutAll,
                        child: const Text('Logout all'),
                    ),
                ],
            ),
            body: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (_, i) {
                    final d = _devices[i];
                    return ListTile(
                        leading: const Icon(Icons.devices_other),
                        title: Text(d.name),
                        subtitle: Text('${d.location} • ${d.lastSeen}'),
                        trailing: IconButton(
                            icon: Icon(Icons.logout, color: cs.error),
                            onPressed: () => _revoke(i),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                    );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemCount: _devices.length,
            ),
        );
    }
}

class _Device {
    final String name;
    final String location;
    final String lastSeen;
    _Device(this.name, this.location, this.lastSeen);
}
