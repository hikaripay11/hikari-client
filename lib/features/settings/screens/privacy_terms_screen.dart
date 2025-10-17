// lib/features/settings/screens/privacy_terms_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyTermsScreen extends StatefulWidget {
    const PrivacyTermsScreen({super.key});

    @override
    State<PrivacyTermsScreen> createState() => _PrivacyTermsScreenState();
}

class _PrivacyTermsScreenState extends State<PrivacyTermsScreen>
        with SingleTickerProviderStateMixin {
    late final TabController _tab;
    String _lang = 'en'; // 'en' | 'ja' | 'ko'
    String _privacy = '';
    String _terms = '';
    bool _loading = true;

    @override
    void initState() {
        super.initState();
        _tab = TabController(length: 2, vsync: this);
        _loadDocs();
    }

    Future<void> _loadDocs() async {
        setState(() => _loading = true);
        _privacy = await _loadAssetOrFallback(_assetPath(isPrivacy: true));
        _terms = await _loadAssetOrFallback(_assetPath(isPrivacy: false));
        if (mounted) setState(() => _loading = false);
    }

    String _assetPath({required bool isPrivacy}) {
        final name = isPrivacy ? 'privacy' : 'terms';
        // 예: assets/policies/privacy_en.md
        return 'assets/policies/${name}_${_lang}.md';
    }

    Future<String> _loadAssetOrFallback(String path) async {
        try {
            return await rootBundle.loadString(path);
        } catch (_) {
            // 기본 템플릿 (언어별 간단 텍스트)
            final title = path.contains('privacy') ? 'Privacy Policy' : 'Terms of Service';
            final localeLabel = _lang == 'ja'
                ? '(日本語)'
                : _lang == 'ko'
                    ? '(한국어)'
                    : '(English)';
            return """
                # $title $localeLabel

                _Last updated: ${DateTime.now().toIso8601String().split('T').first}_

                This is a placeholder document.  
                You can provide your own Markdown at:

                \`$path\`

                **How to replace:**
                - Create the file above in your repo.
                - Rebuild the app.

                For links, we support [external URLs](https://example.com) and email links (mailto:).

                """;
        }
    }

    void _changeLang(String lang) {
        if (_lang == lang) return;
        setState(() => _lang = lang);
        _loadDocs();
    }

    Future<void> _onLinkTap(String text, String? href, String title) async {
        if (href == null) return;
        final uri = Uri.parse(href);
        
        if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not open: $href')),
            );
        }
    }

    @override
    void dispose() {
        _tab.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
            appBar: AppBar(
                title: const Text('Privacy & Terms'),
                bottom: TabBar(
                    controller: _tab,
                    tabs: const [
                        Tab(text: 'Privacy Policy'),
                        Tab(text: 'Terms of Service'),
                    ],
                ),
                actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: _lang,
                                onChanged: (v) => _changeLang(v!),
                                items: const [
                                    DropdownMenuItem(value: 'en', child: Text('EN')),
                                    DropdownMenuItem(value: 'ja', child: Text('日本語')),
                                    DropdownMenuItem(value: 'ko', child: Text('한국어')),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                        onRefresh: _loadDocs,
                        child: TabBarView(
                            controller: _tab,
                            children: [
                                _MarkdownPane(text: _privacy, onLinkTap: _onLinkTap),
                                _MarkdownPane(text: _terms, onLinkTap: _onLinkTap),
                            ],
                        ),
                    ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Text(
                    '© ${DateTime.now().year} Hikari • $_lang'.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                ),
            ),
        );
    }
}

class _MarkdownPane extends StatelessWidget {
    const _MarkdownPane({required this.text, required this.onLinkTap});
    final String text;
    final Future<void> Function(String, String?, String) onLinkTap;

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Markdown(
            data: text,
            selectable: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                blockquoteDecoration: BoxDecoration(
                    border: Border(left: BorderSide(color: cs.outlineVariant, width: 4)),
                    color: cs.surfaceContainerLowest,
                ),
            ),
            onTapLink: onLinkTap,
        );
    }
}
