// lib/features/menu/menu_view.dart
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../../design_system/colors.dart'; // HikariColor 접근 경로 수정
import '../settings/settings_view.dart';
import '../../widgets/svg_icon.dart';

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
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SettingsView()),
                                // iOS 느낌 원하면 CupertinoPageRoute로 교체 가능
                            );
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
                            _ItemData('Send Money', 'send-plane'),
                            _ItemData('Request Money', 'download'),
                        ],
                    ),
                    _Section(
                        title: 'Accounts & Instruments',
                        items: const [
                            _ItemData('Linked Banks', 'bank'),
                            _ItemData('Cards & Payments', 'credit-card'),
                        ],
                    ),
                    _Section(
                        title: 'Activity & Records',
                        items: const [
                            _ItemData('Transaction History', 'exchange-box'),
                            _ItemData('Receipts Box', 'file-list'),
                        ],
                    ),
                    _Section(
                        title: 'Insights & Tools',
                        items: const [
                            _ItemData('Spending Insights', 'bar-chart-2'),
                            _ItemData('Budget & Limits', 'speed-up'),
                            _ItemData('Currency Rates', 'exchange'),
                        ],
                    ),
                    _Section(
                        title: 'Rewards & Growth',
                        items: const [
                            _ItemData('Rewards & Points', 'gift'),
                            _ItemData('Offers & Coupons', 'price-tag'),
                            _ItemData('Invite Friends', 'user-add'),
                        ],
                    ),
                    _Section(
                        title: 'Support & Info',
                        items: const [
                            _ItemData('Help Center', 'question'),
                            _ItemData('Legal & Privacy', 'shield-keyhole'),
                            _ItemData('About Hikari', 'information'),
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
            leading: SvgIcon(data.iconName, size: 20),
            title: Text(
                data.label,
                style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                ),
            ),
            trailing: SvgIcon('arrow-right-s', size: 16, color: cs.onSurface.withOpacity(0.35)),
            onTap: data.onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            horizontalTitleGap: 12,
            minLeadingWidth: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
    }
}

class _ItemData {
    final String label;
    final String iconName;
    final VoidCallback? onTap;
    const _ItemData(this.label, this.iconName, {this.onTap});
}
