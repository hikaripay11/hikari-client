import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart'; // trailing 라벨 화살표 등에 사용 중이면 유지
import '../design_system/colors.dart';
import 'colored_nav_icon.dart'; // ← 추가

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

  final labels  = ['Home', 'Wallet', 'Stats', 'Menu'];
  final assets  = ['home', 'wallet', 'bar_chart', 'menu']; // assets/images/icons/*.svg

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => onTap(i),
    child: Builder(
      builder: (context) {
        final cs = Theme.of(context).colorScheme;

        final Color textColor = selected
            ? HikariColors.primary
            : cs.onSurface.withOpacity(0.55);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // 배지 제거했으니 약간 보강
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 배지(박스) 제거 → 아이콘 단독
              ColoredNavIcon(
                name: assets[i],
                selected: selected,
                size: 22, // 살짝 키워서 존재감 보정
              ),
              const SizedBox(height: 4),
              Text(
                labels[i],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
