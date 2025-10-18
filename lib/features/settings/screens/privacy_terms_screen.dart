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
  late final ScrollController _privacyScroll;
  late final ScrollController _termsScroll;

  String _lang = 'en'; // 'en' | 'ja' | 'ko'
  String _privacy = '';
  String _terms = '';
  bool _loading = true;

  bool _localeApplied = false; // didChangeDependencies에서 1회만 적용

  static const _supported = ['en', 'ja', 'ko'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this)
      ..addListener(() {
        // 탭 전환 시 스크롤 상단으로
        if (_tab.indexIsChanging) return;
        (_tab.index == 0 ? _privacyScroll : _termsScroll).animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    _privacyScroll = ScrollController();
    _termsScroll = ScrollController();
    _loadDocs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_localeApplied) return;
    _localeApplied = true;

    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    if (_supported.contains(code) && code != _lang) {
      _lang = code;
      _loadDocs();
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _privacyScroll.dispose();
    _termsScroll.dispose();
    super.dispose();
  }

  Future<void> _loadDocs() async {
    setState(() => _loading = true);
    try {
      final p = await _loadAssetOrFallback(_assetPath(isPrivacy: true));
      final t = await _loadAssetOrFallback(_assetPath(isPrivacy: false));
      if (!mounted) return;
      setState(() {
        _privacy = p;
        _terms = t;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _privacy = _fallbackDoc(isPrivacy: true);
        _terms = _fallbackDoc(isPrivacy: false);
        _loading = false;
      });
    }
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
      return _fallbackDoc(isPrivacy: path.contains('privacy'));
    }
  }

  String _fallbackDoc({required bool isPrivacy}) {
    final title = isPrivacy ? 'Privacy Policy' : 'Terms of Service';
    final localeLabel = switch (_lang) { 'ja' => '(日本語)', 'ko' => '(한국어)', _ => '(English)' };
    final date = DateTime.now().toIso8601String().split('T').first;
    final path = _assetPath(isPrivacy: isPrivacy);
    return '''
      # $title $localeLabel

      _Last updated: $date

      This is a placeholder document.  
      Provide your own Markdown at:

      `$path`

      **How to replace:**
      - Create the file above in your repo
      - Rebuild the app

      [External link example](https://example.com) and `inline code` sample.

      ```dart
      // fenced code block sample
      void main() => print('Hello Hikari');
      ```
    ''';
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
                  _MarkdownPane(
                    text: _privacy,
                    onLinkTap: _onLinkTap,
                    controller: _privacyScroll,
                  ),
                  _MarkdownPane(
                    text: _terms,
                    onLinkTap: _onLinkTap,
                    controller: _termsScroll,
                  ),
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
  const _MarkdownPane({
    required this.text,
    required this.onLinkTap,
    required this.controller,
  });

  final String text;
  final Future<void> Function(String, String?, String) onLinkTap;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final sheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      // 인라인 코드
      code: theme.textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        backgroundColor: cs.surfaceContainerLowest,
      ),
      // 펜스드 코드 블록
      codeblockDecoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      // 인용문
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: cs.outlineVariant, width: 4)),
        color: cs.surfaceContainerLowest,
      ),
      // 링크 스타일
      a: theme.textTheme.bodyMedium?.copyWith(
        decoration: TextDecoration.underline,
        color: cs.primary,
      ),
      // // 리스트/테이블 폭 대응
      // tablePadding: const EdgeInsets.symmetric(vertical: 8),
    );

    return Markdown(
      data: text,
      selectable: true,
      controller: controller,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      styleSheet: sheet,
      softLineBreak: true,
      onTapLink: onLinkTap,
      imageDirectory: 'assets', // 로컬 이미지 경로 호환
      // fitContent: true, // 테이블/이미지 폭 대응
    );
  }
}
