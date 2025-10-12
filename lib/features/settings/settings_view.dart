// lib/features/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../design_system/colors.dart';

class SettingsView extends StatefulWidget {
    const SettingsView({super.key});

    @override
    State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
    // ---- mock states (연동 전 임시 상태) ----
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
                                icon: Remix.user_3_line,
                                label: 'My Info',
                                onTap: () {
                                    // TODO: 내 정보 화면 (이름/이메일/프로필 이미지)
                                },
                            ),
                            _SettingsTile(
                                icon: Remix.mail_check_line,
                                label: 'Email & Verification',
                                onTap: () {
                                    // TODO: 이메일 변경/인증
                                },
                            ),
                            _SettingsTile(
                                icon: Remix.key_2_line,
                                label: 'Change Password',
                                onTap: () {
                                    // TODO: 비밀번호 변경
                                },
                            ),
                        ],
                    ),

                    _SettingsSection(
                        title: 'Security',
                        children: [
                            _SettingsSwitchTile(
                                icon: Remix.fingerprint_line,
                                label: 'Biometrics (Face/Touch ID)',
                                value: biometrics,
                                onChanged: (v) => setState(() => biometrics = v),
                            ),
                            _SettingsSwitchTile(
                                icon: Remix.shield_keyhole_line,
                                label: 'PIN Lock',
                                value: pinLock,
                                onChanged: (v) => setState(() => pinLock = v),
                            ),
                            _SettingsTile(
                                icon: Remix.device_line,
                                label: 'Trusted Devices',
                                onTap: () {
                                    // TODO: 로그인 기기 관리
                                },
                            ),
                        ],
                    ),

                    _SettingsSection(
                        title: 'Notifications',
                        children: [
                            _SettingsTile(
                                icon: Remix.notification_3_line,
                                label: 'Transfer & Deposit Alerts',
                                onTap: () {
                                    // TODO: 송금/입금 알림 세부설정
                                },
                            ),
                            _SettingsSwitchTile(
                                icon: Remix.megaphone_line,
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
                                icon: Remix.moon_clear_line,
                                label: 'Appearance (Light/Dark)',
                                onTap: () {
                                    // TODO: 다크모드 토글 / 시스템 따라가기
                                },
                            ),
                            _SettingsSwitchTile(
                                icon: Remix.magic_line,
                                label: 'Reduce Motion',
                                value: reduceMotion,
                                onChanged: (v) => setState(() => reduceMotion = v),
                            ),
                            _SettingsTile(
                                icon: Remix.text_spacing,
                                label: 'Text Size',
                                onTap: () {
                                    // TODO: 글자 크기 조정
                                },
                            ),
                        ],
                    ),

                    _SettingsSection(
                        title: 'Data & Storage',
                        children: [
                            _SettingsSwitchTile(
                                icon: Remix.save_3_line,
                                label: 'Auto-save Receipts',
                                value: autoSaveReceipts,
                                onChanged: (v) => setState(() => autoSaveReceipts = v),
                            ),
                            _SettingsTile(
                                icon: Remix.hard_drive_line,
                                label: 'Manage Storage',
                                onTap: () {
                                    // TODO: 캐시/저장공간 관리
                                },
                            ),
                        ],
                    ),

                    _SettingsSection(
                        title: 'Language',
                        children: [
                            _SettingsTile(
                                icon: Remix.translate_2,
                                label: 'App Language (EN / 日本語 / KO)',
                                onTap: () {
                                    // TODO: 언어 선택
                                },
                            ),
                        ],
                    ),

                    _SettingsSection(
                        title: 'About',
                        children: [
                            _SettingsTile(
                                icon: Remix.information_line,
                                label: 'About Hikari',
                                onTap: () {
                                    // TODO: 회사/브랜드 소개
                                },
                            ),
                            _SettingsTile(
                                icon: Remix.book_3_line,
                                label: 'Open Source Licenses',
                                onTap: () {
                                    // TODO: 라이선스 리스트
                                },
                            ),
                            _SettingsTile(
                                icon: Remix.shield_user_line,
                                label: 'Privacy & Terms',
                                onTap: () {
                                    // TODO: 약관/개인정보처리방침
                                },
                            ),
                            _SettingsCaption(
                                text: 'Version 0.1.0 (dev)',
                            ),
                        ],
                    ),
                ],
            ),
        );
    }
}

// ---------------- UI building blocks ----------------

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
                                        Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: cs.onSurface.withOpacity(0.06),
                                        ),
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
    final IconData icon;
    final String label;
    final VoidCallback? onTap;
    const _SettingsTile({required this.icon, required this.label, this.onTap});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return ListTile(
            leading: Icon(icon, size: 22, color: cs.onSurface.withOpacity(0.85)),
            title: Text(
                label,
                style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                ),
            ),
            trailing: Icon(Remix.arrow_right_s_line, size: 18, color: cs.onSurface.withOpacity(0.35)),
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            horizontalTitleGap: 12,
            minLeadingWidth: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
    }
}

class _SettingsSwitchTile extends StatelessWidget {
    final IconData icon;
    final String label;
    final bool value;
    final ValueChanged<bool> onChanged;
    const _SettingsSwitchTile({
        required this.icon,
        required this.label,
        required this.value,
        required this.onChanged,
    });

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return ListTile(
            leading: Icon(icon, size: 22, color: cs.onSurface.withOpacity(0.85)),
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
