import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
    final String name;   // assets/images/icons/{name}.svg
    final double size;
    final Color? color;

    const SvgIcon(this.name, {super.key, this.size = 18, this.color});

    @override
    Widget build(BuildContext context) {
        return SvgPicture.asset(
            'assets/images/icons/$name.svg',
            width: size,
            height: size,
            // 멀티컬러 SVG 그대로 쓰려면 color=null 유지
            colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
    }
}
