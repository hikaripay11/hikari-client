import 'package:flutter/material.dart';

class TxnWaveCard extends StatelessWidget {
    final String name;
    final String date;
    final double amount;
    final String avatarUrl;

    const TxnWaveCard({
        super.key,
        required this.name,
        required this.date,
        required this.amount,
        required this.avatarUrl,
    });

    @override
    Widget build(BuildContext context) {
        final positive = amount >= 0;
        final amountStyle = TextStyle(
            color: positive ? const Color(0xFF16C79A) : const Color(0xFF5A64D8),
            fontWeight: FontWeight.w800,
        );

        return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 10))],
            ),
            child: Stack(
                children: [
                    Positioned.fill(
                        bottom: 0,
                        child: ClipPath(
                            clipper: _WaveClipper(),
                            child: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Color(0x66BEEAFF), Color(0x993C7EF9)],
                                    ),
                                ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(children: [
                                CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
                                const Spacer(),
                                Icon(positive ? Icons.south_east : Icons.north_east, size: 18, color: Colors.black38),
                                ]),
                                const SizedBox(height: 8),
                                Text(
                                (positive ? '+ ' : '- ') + amount.abs().toStringAsFixed(2),
                                style: amountStyle,
                                ),
                                const SizedBox(height: 6),
                                const Text('From', style: TextStyle(color: Colors.black45, fontSize: 12)),
                                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const Spacer(),
                                Text(date, style: const TextStyle(color: Colors.black38, fontSize: 12)),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}

class _WaveClipper extends CustomClipper<Path> {
    @override
    Path getClip(Size size) {
        final p = Path()..moveTo(0, size.height * .45);
        p.quadraticBezierTo(size.width * .25, size.height * .25, size.width * .5, size.height * .45);
        p.quadraticBezierTo(size.width * .75, size.height * .65, size.width, size.height * .45);
        p.lineTo(size.width, size.height);
        p.lineTo(0, size.height);
        p.close();
        return p;
    }

    @override
    bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
