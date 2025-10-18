// lib/features/settings/screens/trusted_devices_screen.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';

class TrustedDevicesScreen extends StatefulWidget {
    const TrustedDevicesScreen({super.key});

    @override
    State<TrustedDevicesScreen> createState() => _TrustedDevicesScreenState();
}

class _TrustedDevicesScreenState extends State<TrustedDevicesScreen> {
    final List<_Device> _devices = [
        _Device(id: 'd1', name: 'iPhone 16', location: 'Paris, FR', lastSeen: 'Active now', isCurrent: true),
        _Device(id: 'd2', name: 'MacBook Pro', location: 'Versailles, FR', lastSeen: 'Last seen 2h ago'),
        _Device(id: 'd3', name: 'iPad', location: 'Seoul, KR', lastSeen: 'Last seen 5d ago'),
    ];

    bool _refreshing = false;

    Future<void> _refresh() async {
        setState(() => _refreshing = true);
        // TODO: 서버에서 최신 기기 목록 가져오기
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        setState(() => _refreshing = false);
    }

    IconData _iconFor(_Device d) {
        final n = d.name.toLowerCase();
        if (n.contains('iphone')) return Icons.phone_iphone;
        if (n.contains('ipad')) return Icons.tablet_mac;
        if (n.contains('mac')) return Icons.laptop_mac;
        if (n.contains('android')) return Icons.android;
        if (n.contains('windows')) return Icons.laptop_windows;
        if (n.contains('linux')) return Icons.laptop;
        if (n.contains('web') || n.contains('browser')) return Icons.language;
        return Icons.devices_other;
    }

    Future<bool> _confirm(String title, String message) async {
        final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
                ],
            ),
        );
        return ok ?? false;
    }

    Future<void> _revokeAt(int index) async {
        final d = _devices[index];
        if (!await _confirm('Log out device?', 'You will be logged out on “${d.name}”.')) return;

        final removed = _devices.removeAt(index);
        setState(() {});
        if (!mounted) return;

        // TODO: 서버 revoke 호출
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Logged out: ${removed.name}'),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                        // 클라이언트 단 UNDO (서버 연동 시에는 취소 API 필요)
                        final i = index.clamp(0, _devices.length);
                        setState(() => _devices.insert(i, removed));
                    },
                ),
            ),
        );
    }

    Future<void> _logoutAll() async {
        if (_devices.isEmpty) return;
        if (!await _confirm('Log out of all devices?', 'You will be logged out everywhere.')) return;

        final snapshot = List<_Device>.from(_devices);
        _devices.clear();
        setState(() {});
        if (!mounted) return;

        // TODO: 서버 logout-all 호출
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Logged out of all devices'),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => setState(() => _devices.addAll(snapshot)),
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

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
            body: RefreshIndicator(
                onRefresh: _refresh,
                child: _devices.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                            const SizedBox(height: 80),
                            Icon(Icons.devices_other, size: 48, color: cs.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Center(
                                child: Text(
                                    'No trusted devices',
                                    style: tt.titleMedium,
                                ),
                            ),
                            const SizedBox(height: 6),
                            Center(
                                child: Text(
                                    'Sign in on a device to see it here.',
                                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                                ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                                child: FilledButton.tonal(
                                    onPressed: _refreshing ? null : _refresh,
                                    child: _refreshing
                                        ? const SizedBox(
                                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                        : const Text('Refresh'),
                                ),
                            ),
                        ],
                    )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (_, i) {
                        final d = _devices[i];
                        final icon = _iconFor(d);
                        return Dismissible(
                            key: ValueKey(d.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                                await _revokeAt(i);
                                return false; // 내부에서 처리(UNDO 지원), 실제 dismiss는 false
                            },
                            background: _SwipeBg(color: cs.error),
                            child: ListTile(
                                leading: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                        Icon(icon, size: 28),
                                        if (d.isCurrent)
                                            Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Icon(Icons.verified, size: 16, color: cs.primary),
                                            ),
                                    ],
                                ),
                                title: Row(
                                    children: [
                                    Expanded(child: Text(d.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                    if (d.isCurrent)
                                        Padding(
                                            padding: const EdgeInsets.only(left: 6),
                                            child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: cs.primaryContainer,
                                                    borderRadius: BorderRadius.circular(999),
                                                ),
                                                child: Text(
                                                    'This device',
                                                    style: tt.labelSmall?.copyWith(color: cs.onPrimaryContainer),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                subtitle: Text('${d.location} • ${d.lastSeen}',
                                    style: TextStyle(color: cs.onSurfaceVariant)),
                                trailing: IconButton(
                                    icon: Icon(Icons.logout, color: cs.error),
                                    tooltip: 'Log out',
                                    onPressed: () => _revokeAt(i),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                        );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: _devices.length,
                ),
            ),
        );
    }
}

class _SwipeBg extends StatelessWidget {
    const _SwipeBg({required this.color});
    final Color color;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Container(
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.logout, color: color),
        );
    }
}

class _Device {
    final String id;
    final String name;
    final String location;
    final String lastSeen;
    final bool isCurrent;

    _Device({
        required this.id,
        required this.name,
        required this.location,
        required this.lastSeen,
        this.isCurrent = false,
    });
}
