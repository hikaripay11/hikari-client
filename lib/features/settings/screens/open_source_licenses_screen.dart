// lib/features/settings/screens/open_source_licenses_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show LicenseRegistry;
import 'package:flutter/services.dart';

/// 패키지명 -> 라이선스 문단(문자열) 리스트를 모아 보여주는 화면
class OpenSourceLicensesScreen extends StatefulWidget {
    const OpenSourceLicensesScreen({super.key});

    @override
    State<OpenSourceLicensesScreen> createState() => _OpenSourceLicensesScreenState();
}

class _OpenSourceLicensesScreenState extends State<OpenSourceLicensesScreen> {
    final Map<String, List<String>> _byPackage = {};
    final TextEditingController _search = TextEditingController();

    bool _loading = true;
    bool _error = false;

    String _appName = 'Hikari';
    String _appVersion = '—';

    String _query = '';
    Timer? _debounce;

    @override
    void initState() {
        super.initState();
        _search.addListener(_onSearchChanged);
        _load();
    }

    @override
    void dispose() {
        _debounce?.cancel();
        _search.removeListener(_onSearchChanged);
        _search.dispose();
        super.dispose();
    }

    void _onSearchChanged() {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 250), () {
            if (!mounted) return;
            setState(() => _query = _search.text);
        });
    }

    Future<void> _load() async {
        setState(() {
            _loading = true;
            _error = false;
        });

        try {
            // 앱 이름/버전
            try {
                final info = await PackageInfo.fromPlatform();
                _appName = info.appName.isNotEmpty ? info.appName : 'Hikari';
                _appVersion = '${info.version} (${info.buildNumber})';
            } catch (_) {
                // package info 실패는 치명적 에러 아님
            }

            // LicenseRegistry에서 엔트리 모으기
            _byPackage.clear();
            await for (final entry in LicenseRegistry.licenses) {
                final text = entry.paragraphs.map((p) => p.text).join('\n\n').trim();
                for (final p in entry.packages) {
                    _byPackage.putIfAbsent(p, () => <String>[]).add(text);
                }
            }

            if (!mounted) return;
            setState(() => _loading = false);
        } catch (_) {
            if (!mounted) return;
            setState(() {
                _loading = false;
                _error = true;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        final packages = _byPackage.keys.toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        final filtered = _query.isEmpty
            ? packages
            : packages.where((p) => p.toLowerCase().contains(_query.toLowerCase())).toList();

        return Scaffold(
        appBar: AppBar(
            title: const Text('Open Source Licenses'),
            actions: [
                IconButton(
                    tooltip: 'System License Page',
                    onPressed: () {
                        showLicensePage(
                            context: context,
                            applicationName: _appName,
                            applicationVersion: _appVersion,
                        );
                    },
                    icon: const Icon(Icons.library_books_outlined),
                ),
                IconButton(
                    tooltip: 'Refresh',
                    onPressed: _loading ? null : _load,
                    icon: const Icon(Icons.refresh),
                ),
            ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error
                ? _ErrorView(onRetry: _load)
                : Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: TextField(
                                controller: _search,
                                decoration: const InputDecoration(
                                    hintText: 'Search packages…',
                                    prefixIcon: Icon(Icons.search),
                                ),
                            ),
                        ),
                        if (filtered.isEmpty)
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Text(
                                'No packages found',
                                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                            ),
                        ),
                        if (filtered.isNotEmpty)
                        Expanded(
                            child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                itemBuilder: (_, i) {
                                    final name = filtered[i];
                                    final items = _byPackage[name]!;
                                    final count = items.length;
                                    final preview = (items.first).split('\n').first.trim();

                                    return ListTile(
                                    title: Text(
                                        name,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                        count == 1 ? preview : '$count licenses • $preview',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: cs.onSurfaceVariant),
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => LicenseDetailScreen(
                                                package: name,
                                                texts: items,
                                            ),
                                        ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    );
                                },
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemCount: filtered.length,
                            ),
                        ),
                    ],
                ),
        bottomNavigationBar: _loading
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                    '$_appName • $_appVersion • ${_byPackage.length} packages',
                    textAlign: TextAlign.center,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
            ),
        );
    }
}

class _ErrorView extends StatelessWidget {
    const _ErrorView({required this.onRetry});
    final VoidCallback onRetry;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(Icons.error_outline, color: cs.onSurfaceVariant),
                    const SizedBox(height: 8),
                    const Text('Failed to load licenses'),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: onRetry, child: const Text('Retry')),
                ],
            ),
        );
    }
}

/// 특정 패키지의 라이선스 전문 보기
class LicenseDetailScreen extends StatelessWidget {
    const LicenseDetailScreen({super.key, required this.package, required this.texts});

    final String package;
    final List<String> texts;

    Future<void> _copyAll(BuildContext context) async {
        final joined = texts.join('\n\n— — —\n\n');
        await Clipboard.setData(ClipboardData(text: joined));
        
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('License text copied')),
        );
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;

        return Scaffold(
            appBar: AppBar(
                title: Text(package),
                actions: [
                    IconButton(
                        tooltip: 'Copy all',
                        onPressed: () => _copyAll(context),
                        icon: const Icon(Icons.copy_all),
                    ),
                ],
            ),
            body: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemBuilder: (_, i) {
                    final t = texts[i];
                    return Container(
                        decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: SelectableText(
                            t,
                            style: tt.bodyMedium,
                        ),
                    );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: texts.length,
            ),
        );
    }
}
