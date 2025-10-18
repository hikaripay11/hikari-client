// lib/features/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:remixicon/remixicon.dart'; // ← 필요시 활성화
import '../../design_system/colors.dart';
import '../../widgets/svg_icon.dart';

// DETAIL SCREENS
import 'screens/my_info_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/trusted_devices_screen.dart';
import 'screens/transfer_deposit_alerts_screen.dart';
import 'screens/appearance_screen.dart';
import 'screens/text_size_screen.dart';
import 'screens/manage_storage_screen.dart';
import 'screens/language_screen.dart';
import 'screens/about_hikari_screen.dart';
import 'screens/open_source_licenses_screen.dart';
import 'screens/privacy_terms_screen.dart';

// ⚙️ 로컬 저장 키(간단 prefs)
const _kBiometrics = 'settings.security.biometrics';
const _kPinLock = 'settings.security.pinlock';
const _kMarketing = 'settings.notifications.marketing';
const _kReduceMotion = 'settings.ui.reduce_motion';
const _kAutoSaveReceipts = 'settings.storage.autosave_receipts';

// 아래 두 개는 우리가 앞서 만든 settingsProvider를 안 쓰는 경우를 대비한 요약 표시용 키 예시
const _kLangCode = 'settings.lang';         // 'en' | 'ja' | 'ko' | 'fr' (선택 화면에서 저장됨)
const _kTextScale = 'settings.textscale';   // double (0.85~1.30)

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool loading = true;

  bool biometrics = true;
  bool pinLock = true;
  bool marketing = false;
  bool reduceMotion = false;
  bool autoSaveReceipts = true;

  // 요약 표시
  String _languageSummary = 'System';
  String _textSizeSummary = '100%';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      biometrics = p.getBool(_kBiometrics) ?? true;
      pinLock = p.getBool(_kPinLock) ?? true;
      marketing = p.getBool(_kMarketing) ?? false;
      reduceMotion = p.getBool(_kReduceMotion) ?? false;
      autoSaveReceipts = p.getBool(_kAutoSaveReceipts) ?? true;

      final lang = p.getString(_kLangCode);
      _languageSummary = switch (lang) {
        'ja' => '日本語',
        'ko' => '한국어',
        'fr' => 'Français',
        'en' => 'English',
        _ => 'System',
      };
      final scale = (p.getDouble(_kTextScale) ?? 1.0);
      _textSizeSummary = '${(scale * 100).round()}%';

      loading = false;
    });
  }

  Future<void> _setPrefBool(String key, bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(key, value);
  }

  // 화면 복귀 시 요약 텍스트 최신화(언어/텍스트 사이즈 등)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 가벼운 비동기로 다시 읽어 최신 상태 반영
    Future.microtask(_loadPrefs);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _SettingsSection(
                  title: 'Account',
                  children: [
                    _SettingsTile(
                      iconName: 'user',
                      label: 'My Info',
                      onTap: () => _go(context, const MyInfoScreen()),
                    ),
                    _SettingsTile(
                      iconName: 'mail-check',
                      label: 'Email & Verification',
                      onTap: () => _go(context, const EmailVerificationScreen()),
                    ),
                    _SettingsTile(
                      iconName: 'key',
                      label: 'Change Password',
                      onTap: () => _go(context, const ChangePasswordScreen()),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Security',
                  children: [
                    _SettingsSwitchTile(
                      iconName: 'fingerprint',
                      label: 'Biometrics (Face/Touch ID)',
                      value: biometrics,
                      onChanged: (v) async {
                        setState(() => biometrics = v);
                        await _setPrefBool(_kBiometrics, v);
                      },
                    ),
                    _SettingsSwitchTile(
                      iconName: 'shield-keyhole',
                      label: 'PIN Lock',
                      value: pinLock,
                      onChanged: (v) async {
                        setState(() => pinLock = v);
                        await _setPrefBool(_kPinLock, v);
                      },
                    ),
                    _SettingsTile(
                      iconName: 'device',
                      label: 'Trusted Devices',
                      onTap: () => _go(context, const TrustedDevicesScreen()),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Notifications',
                  children: [
                    _SettingsTile(
                      iconName: 'notification',
                      label: 'Transfer & Deposit Alerts',
                      onTap: () => _go(context, const TransferDepositAlertsScreen()),
                    ),
                    _SettingsSwitchTile(
                      iconName: 'megaphone',
                      label: 'Marketing Messages',
                      value: marketing,
                      onChanged: (v) async {
                        setState(() => marketing = v);
                        await _setPrefBool(_kMarketing, v);
                      },
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Display & Theme',
                  children: [
                    _SettingsTile(
                      iconName: 'moon-clear',
                      label: 'Appearance (Light/Dark)',
                      onTap: () => _go(context, const AppearanceScreen()),
                    ),
                    _SettingsSwitchTile(
                      iconName: 'magic',
                      label: 'Reduce Motion',
                      value: reduceMotion,
                      onChanged: (v) async {
                        setState(() => reduceMotion = v);
                        await _setPrefBool(_kReduceMotion, v);
                        // TODO: 애니메이션 전역 스케일/기간을 이 값으로 제어하고 싶으면 theme/builder에서 참고
                      },
                    ),
                    _SettingsTile(
                      iconName: 'text-spacing',
                      label: 'Text Size',
                      onTap: () async {
                        await _go(context, const TextSizeScreen());
                        if (mounted) _loadPrefs(); // 돌아왔을 때 요약 업데이트
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 54, right: 14, bottom: 10),
                      child: Row(
                        children: [
                          Text('Text scale • $_textSizeSummary',
                              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Data & Storage',
                  children: [
                    _SettingsSwitchTile(
                      iconName: 'save',
                      label: 'Auto-save Receipts',
                      value: autoSaveReceipts,
                      onChanged: (v) async {
                        setState(() => autoSaveReceipts = v);
                        await _setPrefBool(_kAutoSaveReceipts, v);
                      },
                    ),
                    _SettingsTile(
                      iconName: 'storage',
                      label: 'Manage Storage',
                      onTap: () => _go(context, const ManageStorageScreen()),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Language',
                  children: [
                    _SettingsTile(
                      iconName: 'translate',
                      label: 'App Language (EN / 日本語 / KO)',
                      onTap: () async {
                        await _go(context, const LanguageScreen());
                        if (mounted) _loadPrefs(); // 돌아오면 현재 언어 요약 업데이트
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 54, right: 14, bottom: 10),
                      child: Row(
                        children: [
                          Text('Current • $_languageSummary',
                              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'About',
                  children: [
                    _SettingsTile(
                      iconName: 'information',
                      label: 'About Hikari',
                      onTap: () => _go(context, const AboutHikariScreen()),
                    ),
                    _SettingsTile(
                      iconName: 'book',
                      label: 'Open Source Licenses',
                      onTap: () => _go(context, const OpenSourceLicensesScreen()),
                    ),
                    _SettingsTile(
                      iconName: 'shield-user',
                      label: 'Privacy & Terms',
                      onTap: () => _go(context, const PrivacyTermsScreen()),
                    ),
                    const _SettingsCaption(text: 'Version 0.1.0 (dev)'),
                  ],
                ),
              ],
            ),
    );
  }

  static Future<void> _go(BuildContext context, Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

// ---------- UI blocks (원본 유지 + 약간만 보정) ----------

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              )),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.onSurface.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    Divider(height: 1, thickness: 1, color: cs.onSurface.withValues(alpha: 0.06)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String iconName;
  final String label;
  final VoidCallback? onTap;
  const _SettingsTile({required this.iconName, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: SvgIcon(iconName, size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: SvgIcon('arrow-right-s', size: 16, color: cs.onSurface.withValues(alpha: 0.35)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      horizontalTitleGap: 12,
      minLeadingWidth: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final String iconName;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchTile({
    required this.iconName,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: SvgIcon(iconName, size: 20),
      title: Text(
        label,
        style: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: HikariColors.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      horizontalTitleGap: 12,
      minLeadingWidth: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _SettingsCaption extends StatelessWidget {
  final String text;
  const _SettingsCaption({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
