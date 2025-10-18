import 'package:flutter/material.dart';
import '../../../design_system/colors.dart';

class HeaderBalance extends StatelessWidget {
    final String amount;
    const HeaderBalance({super.key, required this.amount});

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8))],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        children: [
                            Icon(Icons.menu_rounded, color: Colors.indigo.shade900),
                            const Spacer(),
                            Stack(children: [
                                Icon(Icons.notifications_none_rounded, color: Colors.indigo.shade900),
                                const Positioned(right: 0, top: 0, child: _Dot()),
                            ])
                        ],
                    ),
                    const SizedBox(height: 18),
                    Text('Current Balance',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black45)),
                    const SizedBox(height: 8),
                    ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                            colors: [Color(0xFF7FB7FF), Color(0xFF3C7EF9)],
                        ).createShader(rect),
                        child: Text(
                            amount,
                            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                    ),
                    const SizedBox(height: 16),
                    const _ThinCard(),
                ],
            ),
        );
    }
}

class _ThinCard extends StatelessWidget {
    const _ThinCard();

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF1C3FAA).withValues(alpha: 0.25), width: 1.5),
            ),
            child: const Row(
                children: [
                    Icon(Icons.credit_card, color: HikariColors.primary),
                    SizedBox(width: 12),
                    Expanded(child: Text('VISA • 6253')),
                    Text('\$758964.10',
                        style: TextStyle(
                            color: HikariColors.primary,
                            fontWeight: FontWeight.w700,
                        )),
                ],
            ),
        );
    }
}

class _Dot extends StatelessWidget {
    const _Dot();

    @override
    Widget build(BuildContext context) {
        return Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle));
    }
}
