// lib/features/settings/screens/about_hikari_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutHikariScreen extends StatefulWidget {
    const AboutHikariScreen({super.key});

    @override
    State<AboutHikariScreen> createState() => _AboutHikariScreenState();
}

class _AboutHikariScreenState extends State<AboutHikariScreen> {
    String _version = '—';
    String _buildNumber = '—';
    String _appName = 'Hikari';
    String _packageName = '—';

    bool _devPanel = false;
    int _logoTap = 0;

    @override
    void initState() {
        super.initState();
        _load();
    }

    Future<void> _load() async {
        try {
            final info = await PackageInfo.fromPlatform();
            if (!mounted) return;
            setState(() {
                _version = info.version;
                _buildNumber = info.buildNumber;
                _appName = (info.appName.isNotEmpty) ? info.appName : 'Hikari';
                _packageName = info.packageName;
            });
        } catch (_) {
            // ignore: failed to read package info
        }
    }

    void _copy(String text, String toast) {
        Clipboard.setData(ClipboardData(text: text));
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(toast)));
    }

    void _onLogoTap() {
        _logoTap++;
        if (_logoTap >= 7 && !_devPanel) {
            setState(() => _devPanel = true);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Developer panel unlocked')),
            );
        }
    }

    String get _buildMode =>
        kReleaseMode ? 'release' : (kProfileMode ? 'profile' : 'debug');

    String get _platformLabel {
        if (kIsWeb) return 'web (${describeEnum(defaultTargetPlatform)})';
        // dart:io 없이 안전하게 표기
        return describeEnum(defaultTargetPlatform);
    }

    Future<void> _openMail(String email) async {
        final uri = Uri.parse('mailto:$email');

        if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
        } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open mail composer')),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
            appBar: AppBar(title: const Text('About Hikari')),
            body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                    // Header
                    Center(
                        child: Column(
                            children: [
                                GestureDetector(
                                    onTap: _onLogoTap,
                                    child: Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                            color: cs.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                                color: cs.outlineVariant.withValues(alpha: 0.5),
                                            ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                            'assets/images/logo.png',
                                            width: 52,
                                            height: 52,
                                            fit: BoxFit.contain,
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                    _appName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                    'Simple remittance, clean & secure',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: cs.onSurfaceVariant),
                                ),
                            ],
                        ),
                    ),

                    const SizedBox(height: 20),

                    // Version
                    const _Section(title: 'App'),
                    _Tile(
                        title: 'Version',
                        subtitle: '$_version ($_buildNumber)',
                        onTap: () => _copy('$_version ($_buildNumber)', 'Version copied'),
                        trailing: const Icon(Icons.copy, size: 18),
                    ),
                    _Tile(
                        title: 'Release notes',
                        subtitle: 'What’s new in this version',
                        onTap: () {
                            // TODO: in-app changelog / webview
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Release notes (TBD)')),
                            );
                        },
                        trailing: const Icon(Icons.chevron_right),
                    ),

                    const SizedBox(height: 16),

                    // Legal
                    const _Section(title: 'Legal'),
                    _Tile(
                        title: 'Privacy Policy',
                        onTap: () {
                            // TIP: in-app markdown viewer가 있다면 이 라우트로 연결
                            // Navigator.of(context).pushNamed('/policies/privacy');
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Open Privacy Policy (TBD)')),
                            );
                        },
                        trailing: const Icon(Icons.chevron_right),
                    ),
                    _Tile(
                        title: 'Terms of Service',
                        onTap: () {
                            // Navigator.of(context).pushNamed('/policies/terms');
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Open Terms of Service (TBD)')),
                            );
                        },
                        trailing: const Icon(Icons.chevron_right),
                    ),
                    _Tile(
                        title: 'Open Source Licenses',
                        onTap: () {
                            showLicensePage(
                                context: context,
                                applicationName: _appName,
                                applicationVersion: '$_version ($_buildNumber)',
                            );
                        },
                        trailing: const Icon(Icons.chevron_right),
                    ),

                    const SizedBox(height: 16),

                    // Support
                    const _Section(title: 'Support'),
                    _Tile(
                        title: 'Contact support',
                        subtitle: 'support@hikaripay.app',
                        onTap: () => _openMail('support@hikaripay.app'),
                        trailing: const Icon(Icons.chevron_right),
                    ),
                    _Tile(
                        title: 'Acknowledgements',
                        onTap: () {
                            // TODO: open credits markdown
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Acknowledgements (TBD)')),
                            );
                        },
                        trailing: const Icon(Icons.chevron_right),
                    ),

                    // Dev / Diagnostics (hidden)
                    if (_devPanel) ...[
                        const SizedBox(height: 16),
                        const _Section(title: 'Developer · Diagnostics'),
                        _Tile(
                            title: 'Package name',
                            subtitle: _packageName,
                            onTap: () => _copy(_packageName, 'Package name copied'),
                            trailing: const Icon(Icons.copy, size: 18),
                        ),
                        _Tile(
                            title: 'Build mode',
                            subtitle: _buildMode,
                        ),
                        _Tile(
                            title: 'Platform',
                            subtitle: _platformLabel,
                        ),
                    ],

                    const SizedBox(height: 8),
                    Center(
                        child: Text(
                            '© ${DateTime.now().year} Hikari',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                    ),
                    const SizedBox(height: 8),
                ],
            ),
        );
    }
}

// --- UI helpers ---

class _Section extends StatelessWidget {
    final String title;
    const _Section({required this.title});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, top: 6),
            child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                ),
            ),
        );
    }
}

class _Tile extends StatelessWidget {
    final String title;
    final String? subtitle;
    final VoidCallback? onTap;
    final Widget? trailing;

    const _Tile({
        required this.title,
        this.subtitle,
        this.onTap,
        this.trailing,
    });

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return ListTile(
            onTap: onTap,
            title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: (subtitle == null)
                ? null
                : Text(
                        subtitle!,
                        style: TextStyle(color: cs.onSurfaceVariant),
                    ),
            trailing: trailing,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        );
    }
}
