import 'package:flutter/material.dart';
// import 'package:remixicon/remixicon.dart'; // ← 사용 안해서 주석 처리(원하면 유지 가능)
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

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool biometrics = true;
  bool pinLock = true;
  bool marketing = false;
  bool reduceMotion = false;
  bool autoSaveReceipts = true;

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
      body: ListView(
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
                onChanged: (v) => setState(() => biometrics = v),
              ),
              _SettingsSwitchTile(
                iconName: 'shield-keyhole',
                label: 'PIN Lock',
                value: pinLock,
                onChanged: (v) => setState(() => pinLock = v),
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
                onChanged: (v) => setState(() => marketing = v),
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
                onChanged: (v) => setState(() => reduceMotion = v),
              ),
              _SettingsTile(
                iconName: 'text-spacing',
                label: 'Text Size',
                onTap: () => _go(context, const TextSizeScreen()),
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
                onChanged: (v) => setState(() => autoSaveReceipts = v),
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
                onTap: () => _go(context, const LanguageScreen()),
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
                onTap: () {
                  // TODO: 화면 연결
                },
              ),
              _SettingsTile(
                iconName: 'shield-user',
                label: 'Privacy & Terms',
                onTap: () {
                  // TODO: 화면 연결
                },
              ),
              const _SettingsCaption(text: 'Version 0.1.0 (dev)'),
            ],
          ),

          // 위 About 섹션을 내비게이션으로 바꾸고 싶다면 위의 const Tiles를 아래처럼 바꿔도 됨:
          /*
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(iconName: 'information', label: 'About Hikari',
                onTap: () => _go(context, const AboutHikariScreen())),
              _SettingsTile(iconName: 'book', label: 'Open Source Licenses',
                onTap: () => _go(context, const OpenSourceLicensesScreen())),
              _SettingsTile(iconName: 'shield-user', label: 'Privacy & Terms',
                onTap: () => _go(context, const PrivacyTermsScreen())),
              const _SettingsCaption(text: 'Version 0.1.0 (dev)'),
            ],
          ),
          */
        ],
      ),
    );
  }

  static void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

// ---------- UI blocks (원본 유지) ----------

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
                color: cs.onSurface.withOpacity(0.75),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              )),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: cs.onSurface.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    Divider(height: 1, thickness: 1, color: cs.onSurface.withOpacity(0.06)),
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
      trailing: SvgIcon('arrow-right-s', size: 16, color: cs.onSurface.withOpacity(0.35)),
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
            color: cs.onSurface.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
