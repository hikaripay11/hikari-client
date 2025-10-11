import 'package:flutter/material.dart';
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
                    color: cs.surface, // 기존: Colors.white
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

    // 사람 → 햄버거로 교체 (Icons.menu_rounded)
    final icons = <IconData>[
        Icons.home_rounded,
        Icons.account_balance_wallet_rounded,
        Icons.bar_chart_rounded,
        Icons.menu_rounded, // ← 여기 변경됨
    ];

    return GestureDetector(
        onTap: () => onTap(i),
        child: Builder(
            builder: (context) {
                final cs = Theme.of(context).colorScheme;
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: selected ? HikariColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                        icons[i],
                        color: selected ? Colors.white : cs.onSurface.withOpacity(0.45), // 기존: Colors.black45
                    ),
                );
            },
        ),
    );
}
