// lib/widgets/pill_navbar.dart
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import '../design_system/colors.dart';

class PillNavBar extends StatelessWidget {
    final int currentIndex;
    final ValueChanged<int> onTap;
    const PillNavBar({super.key, required this.currentIndex, required this.onTap});

    @override
    Widget build(BuildContext context) {
        final cs = Theme.of(context).colorScheme;

        return SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                        BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                        )
                    ],
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (i) => _Item(i, currentIndex, onTap)),
                ),
            ),
        );
    }
}

Widget _Item(int i, int current, ValueChanged<int> onTap) {
    final selected = i == current;

    // Remix 아이콘 (line 스타일)
    final icons = <IconData>[
        Remix.home_line,       // 홈
        Remix.wallet_line,     // 지갑
        Remix.bar_chart_line,  // 통계
        Remix.menu_2_line,         // 햄버거 메뉴
    ];

    final labels = ['Home', 'Wallet', 'Stats', 'Menu'];

    return GestureDetector(
        onTap: () => onTap(i),
        child: Builder(
            builder: (context) {
                final cs = Theme.of(context).colorScheme;
                final color = selected
                    ? HikariColors.primary
                    : cs.onSurface.withOpacity(0.55);

                return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(icons[i], size: 24, color: color),
                            const SizedBox(height: 4),
                            Text(
                                labels[i],
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: color,
                                ),
                            ),
                        ],
                    ),
                );
            },
        ),
    );
}
