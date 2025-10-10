import 'package:flutter/material.dart';

class HikariColors {
    static const primary = Color(0xFF3C7EF9);
    static const primaryLight = Color(0xFF8FD3FE);
    static const secondary = Color(0xFFF6C445);

    static const success = Color(0xFF16C79A);
    static const danger = Color(0xFFF97068);

    static const surfaceLight = Color(0xFFF4F6F8);
    static const surfaceDark = Color(0xFF0E162A);
    static const textPrimary = Color(0xFF1E293B);
    static const textSecondary = Color(0xFF64748B);
    static const border = Color(0xFFE2E8F0);

    static const balanceGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryLight, primary],
    );
}
