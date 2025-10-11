// lib/features/menu/menu_view.dart
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../design_system/colors.dart'; // HikariColor 접근 경로 수정

class MenuView extends StatelessWidget {
    const MenuView({super.key});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        final bottomSafe = MediaQuery.of(context).padding.bottom;
        const pillHeight = 76.0; // PillNavBar 대략 높이(+마진) 만큼

        return Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
                backgroundColor: cs.surface,
                elevation: 0,
                centerTitle: false,
                title: Text(
                    'Menu',
                    style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                    ),
                ),
                actions: [
                    IconButton(
                        icon: const Icon(Remix.settings_3_line, size: 22),
                        color: cs.onSurface.withOpacity(0.85),
                        tooltip: 'Settings',
                        onPressed: () {
                            // TODO: SettingsView 연결
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsView()));
                        },
                    ),
                ],
            ),
            body: ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, bottomSafe + 4),
                children: [
                    _Section(
                        title: 'Money Actions',
                        items: const [
                            _ItemData('Send Money', Remix.send_plane_line),
                            _ItemData('Request Money', Remix.download_2_line),
                        ],
                    ),
                    _Section(
                        title: 'Accounts & Instruments',
                        items: const [
                            _ItemData('Linked Banks', Remix.bank_line),
                            _ItemData('Cards & Payments', Remix.bank_card_line),
                        ],
                    ),
                    _Section(
                        title: 'Activity & Records',
                        items: const [
                            _ItemData('Transaction History', Remix.exchange_box_line),
                            _ItemData('Receipts Box', Remix.file_list_3_line),
                        ],
                    ),
                    _Section(
                        title: 'Insights & Tools',
                        items: const [
                            _ItemData('Spending Insights', Remix.bar_chart_2_line),
                            _ItemData('Budget & Limits', Remix.speed_up_line),
                            _ItemData('Currency Rates', Remix.exchange_line),
                        ],
                    ),
                    _Section(
                        title: 'Rewards & Growth',
                        items: const [
                            _ItemData('Rewards & Points', Remix.gift_line),
                            _ItemData('Offers & Coupons', Remix.price_tag_3_line),
                            _ItemData('Invite Friends', Remix.user_add_line),
                        ],
                    ),
                    _Section(
                        title: 'Support & Info',
                        items: const [
                            _ItemData('Help Center', Remix.question_line),
                            _ItemData('Legal & Privacy', Remix.shield_keyhole_line),
                            _ItemData('About Hikari', Remix.information_line),
                        ],
                    ),
                    const SizedBox(height: 8),
                ],
            ),
        );
    }
}

// ------------------------ UI 컴포넌트 ------------------------

class _Section extends StatelessWidget {
    final String title;
    final List<_ItemData> items;
    final bool isLast;
    
    const _Section({
        required this.title,
        required this.items,
        this.isLast = false,
    });

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        title,
                        style: TextStyle(
                            color: cs.onSurface.withOpacity(0.75),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                        ),
                    ),
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
                                for (int i = 0; i < items.length; i++) ...[
                                _MenuTile(data: items[i]),
                                if (i != items.length - 1)
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

class _MenuTile extends StatelessWidget {
    final _ItemData data;
    const _MenuTile({required this.data});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;
        return ListTile(
            leading: Icon(data.icon, size: 22, color: cs.onSurface.withOpacity(0.85)),
            title: Text(
                data.label,
                style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                ),
            ),
            trailing: Icon(Remix.arrow_right_s_line, size: 18, color: cs.onSurface.withOpacity(0.35)),
            onTap: () {
                // TODO: 라우팅 연결 (각 서비스 화면으로 이동)
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            horizontalTitleGap: 12,
            minLeadingWidth: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
    }
}

class _ItemData {
    final String label;
    final IconData icon;
    const _ItemData(this.label, this.icon);
}
