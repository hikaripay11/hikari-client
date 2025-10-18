// lib/features/settings/screens/manage_storage_screen.dart
import 'dart:async';
import 'dart:io' show Directory, FileSystemEntity, FileSystemEntityType;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStorageScreen extends StatefulWidget {
    const ManageStorageScreen({super.key});

    @override
    State<ManageStorageScreen> createState() => _ManageStorageScreenState();
}

class _ManageStorageScreenState extends State<ManageStorageScreen> {
    // prefs keys
    static const _kLimitMb = 'storage.cache.limit_mb';
    static const _kWifiOnly = 'storage.wifi_only';
    static const _kAutoStmt = 'storage.autodl_statements';

    // UI state
    double _limitMb = 256;
    bool _wifiOnly = true;
    bool _autoDownloadStatements = true;

    // usage state
    int _cacheBytes = 0;
    bool _loadingUsage = false;
    bool _clearing = false;

    @override
    void initState() {
        super.initState();
        _loadPrefs();
        _refreshUsage();
    }

    Future<void> _loadPrefs() async {
        final p = await SharedPreferences.getInstance();
        setState(() {
            _limitMb = p.getDouble(_kLimitMb) ?? 256;
            _wifiOnly = p.getBool(_kWifiOnly) ?? true;
            _autoDownloadStatements = p.getBool(_kAutoStmt) ?? true;
        });
    }

    Future<void> _savePrefs() async {
        final p = await SharedPreferences.getInstance();
        await p.setDouble(_kLimitMb, _limitMb);
        await p.setBool(_kWifiOnly, _wifiOnly);
        await p.setBool(_kAutoStmt, _autoDownloadStatements);
    }

    Future<void> _refreshUsage() async {
        if (kIsWeb) {
            // 웹 빌드는 파일시스템이 없어 사용량 계산 불가
            setState(() {
                _cacheBytes = 0;
                _loadingUsage = false;
            });
            return;
        }
        setState(() => _loadingUsage = true);

        try {
            final dir = await getTemporaryDirectory(); // 캐시 의미로 temp 사용
            final bytes = await _dirSizeSafe(dir);
            if (!mounted) return;
            setState(() {
                _cacheBytes = bytes;
                _loadingUsage = false;
            });
        } catch (_) {
            if (!mounted) return;
            setState(() => _loadingUsage = false);
        }
    }

    Future<int> _dirSizeSafe(Directory dir) async {
        int size = 0;
        try {
            final entities = dir.list(recursive: true, followLinks: false);
            await for (final e in entities) {
                try {
                    final type = await FileSystemEntity.type(e.path, followLinks: false);
                    if (type == FileSystemEntityType.file) {
                        final stat = await e.stat();
                        size += stat.size;
                    }
                } catch (_) {
                    // ignore entry errors
                }
            }
        } catch (_) {
            // ignore
        }
        return size;
    }

    Future<void> _clearCache() async {
        if (kIsWeb) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache clearing isn’t supported on Web')),
            );
            return;
        }

        setState(() => _clearing = true);

        try {
            final tmp = await getTemporaryDirectory();
            await _deleteChildren(tmp);
            await _refreshUsage();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
            );
        } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to clear cache: $e')),
            );
        } finally {
            if (mounted) setState(() => _clearing = false);
        }
    }

    Future<void> _deleteChildren(Directory dir) async {
        try {
            final list = dir.list(recursive: false, followLinks: false);
            await for (final e in list) {
                try {
                    await e.delete(recursive: true);
                } catch (_) {
                    // ignore delete errors
                }
            }
        } catch (_) {
            // ignore
        }
    }

    String _fmtBytes(int bytes) {
        const kb = 1024;
        const mb = kb * 1024;
        const gb = mb * 1024;

        if (bytes >= gb) {
            return '${(bytes / gb).toStringAsFixed(2)} GB';
        } else if (bytes >= mb) {
            return '${(bytes / mb).toStringAsFixed(1)} MB';
        } else if (bytes >= kb) {
            return '${(bytes / kb).toStringAsFixed(0)} KB';
        }
        return '$bytes B';
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        final usageMb = _cacheBytes / (1024 * 1024);
        final ratio = (_limitMb <= 0) ? 0.0 : (usageMb / _limitMb).clamp(0.0, 1.0);

        return Scaffold(
            appBar: AppBar(title: const Text('Manage Storage')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    // Usage card
                    Container(
                        decoration: BoxDecoration(
                            color: cs.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Cache usage', style: tt.labelLarge?.copyWith(
                                    color: cs.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                )),
                                const SizedBox(height: 8),
                                if (_loadingUsage)
                                const LinearProgressIndicator()
                                else
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                        value: ratio,
                                        minHeight: 10,
                                    ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    children: [
                                        Text(_loadingUsage ? 'Measuring…' : _fmtBytes(_cacheBytes)),
                                        const Spacer(),
                                        Text('Limit ${_limitMb.round()} MB',
                                            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                    ],
                                ),
                            ],
                        ),
                    ),

                    const SizedBox(height: 16),

                    // Limit slider
                    Text(
                        'Cache size limit',
                        style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    Slider(
                        value: _limitMb,
                        min: 64,
                        max: 1024,
                        divisions: 15,
                        label: '${_limitMb.round()} MB',
                        onChanged: (v) => setState(() => _limitMb = v),
                        onChangeEnd: (_) async {
                            await _savePrefs();
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Limit set to ${_limitMb.round()} MB')),
                            );
                        },
                    ),

                    // Wi-Fi only
                    SwitchListTile(
                        value: _wifiOnly,
                        onChanged: (v) async {
                            setState(() => _wifiOnly = v);
                            await _savePrefs();
                        },
                        title: const Text('Download on Wi-Fi only'),
                        subtitle: const Text('Avoid large downloads on cellular data'),
                    ),

                    // Auto-download statements
                    SwitchListTile(
                        value: _autoDownloadStatements,
                        onChanged: (v) async {
                            setState(() => _autoDownloadStatements = v);
                            await _savePrefs();
                        },
                        title: const Text('Auto-download monthly statements'),
                        subtitle: const Text('Statements are cached for offline viewing'),
                    ),

                    const SizedBox(height: 8),

                    // Buttons
                    Row(
                        children: [
                            Expanded(
                                child: FilledButton.tonal(
                                    onPressed: _clearing ? null : _clearCache,
                                    child: _clearing
                                        ? const SizedBox(
                                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                        : const Text('Clear cache'),
                                ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                                tooltip: 'Refresh usage',
                                onPressed: _loadingUsage ? null : _refreshUsage,
                                icon: const Icon(Icons.refresh),
                            ),
                        ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                        kIsWeb
                            ? 'Note: Web build uses the browser’s storage; usage cannot be measured here.'
                            : 'Tip: Clearing cache does not affect your account data.',
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                ],
            ),
        );
    }
}
