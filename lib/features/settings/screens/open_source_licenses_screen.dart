// lib/features/settings/screens/open_source_licenses_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show LicenseRegistry;

/// 패키지명 -> 라이선스 문단(문자열) 리스트를 모아 보여주는 화면
class OpenSourceLicensesScreen extends StatefulWidget {
    const OpenSourceLicensesScreen({super.key});

    @override
    State<OpenSourceLicensesScreen> createState() => _OpenSourceLicensesScreenState();
}

class _OpenSourceLicensesScreenState extends State<OpenSourceLicensesScreen> {
    final Map<String, List<String>> _byPackage = {};
    bool _loading = true;
    String _appName = 'Hikari';
    String _appVersion = '—';

    String _query = '';

    @override
    void initState() {
        super.initState();
        _load();
    }

    Future<void> _load() async {
        // 앱 이름/버전
        try {
            final info = await PackageInfo.fromPlatform();
            _appName = info.appName.isNotEmpty ? info.appName : 'Hikari';
            _appVersion = '${info.version} (${info.buildNumber})';
        } catch (_) {}

        // LicenseRegistry에서 엔트리 모으기 (await for)
        await for (final entry in LicenseRegistry.licenses) {
            final text = entry.paragraphs.map((p) => p.text).join('\n\n').trim();
            for (final p in entry.packages) {
                _byPackage.putIfAbsent(p, () => <String>[]).add(text);
            }
        }

        if (mounted) setState(() => _loading = false);
    }


    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        final packages = _byPackage.keys.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
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
                        // Flutter 내장 라이선스 페이지로도 바로 접근 가능
                        showLicensePage(
                            context: context,
                            applicationName: _appName,
                            applicationVersion: _appVersion,
                        );
                    },
                    icon: const Icon(Icons.library_books_outlined),
                ),
            ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: TextField(
                            decoration: const InputDecoration(
                                hintText: 'Search packages…',
                                prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (v) => setState(() => _query = v),
                        ),
                    ),
                    Expanded(
                        child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemBuilder: (_, i) {
                                final name = filtered[i];
                                final count = _byPackage[name]?.length ?? 0;
                                final preview = (_byPackage[name]?.first ?? '').split('\n').first.trim();
                                return ListTile(
                                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                                                texts: _byPackage[name]!,
                                            ),
                                        ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
            ),
        );
    }
}

/// 특정 패키지의 라이선스 전문 보기
class LicenseDetailScreen extends StatelessWidget {
    const LicenseDetailScreen({super.key, required this.package, required this.texts});

    final String package;
    final List<String> texts;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Scaffold(
            appBar: AppBar(title: Text(package)),
            body: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemBuilder: (_, i) {
                    final t = texts[i];
                    return Container(
                        decoration: BoxDecoration(
                            color: cs.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: SelectableText(
                            t,
                            style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: texts.length,
            ),
        );
    }
}
