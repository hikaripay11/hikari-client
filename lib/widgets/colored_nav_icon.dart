// lib/widgets/colored_nav_icon.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ColoredNavIcon extends StatelessWidget {
    final String name;   // 'home', 'wallet', 'bar_chart', 'menu'
    final bool selected;
    final double size;

    const ColoredNavIcon({
        super.key,
        required this.name,
        required this.selected,
        this.size = 18,
    });

    // 채도(saturation) 필터: s=0 → 흑백, s=1 → 원본
    ColorFilter _saturation(double s) {
        const r = 0.2126, g = 0.7152, b = 0.0722;
        return ColorFilter.matrix(<double>[
        r*(1-s)+s, g*(1-s),   b*(1-s),   0, 0,
        r*(1-s),   g*(1-s)+s, b*(1-s),   0, 0,
        r*(1-s),   g*(1-s),   b*(1-s)+s, 0, 0,
        0,         0,         0,         1, 0,
        ]);
    }

    @override
    Widget build(BuildContext context) {
        final pic = SvgPicture.asset(
            'assets/images/icons/$name.svg',
            width: size,
            height: size,
            // 멀티컬러 SVG → color 지정하지 않음
        );

        final child = selected
            ? pic
            : Opacity(
                opacity: 0.68,
                child: ColorFiltered(colorFilter: _saturation(0), child: pic),
            );

        return AnimatedScale(
            scale: selected ? 1.0 : 0.96,
            duration: const Duration(milliseconds: 140),
            child: child,
        );
    }
}
