// lib/splash/splash_view.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../app.dart'; // NavShell 접근

class SplashView extends StatefulWidget {
    const SplashView({super.key});

    @override
    State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
    late final AnimationController _controller;
    late final Animation<double> _fade;

    static const _hold = Duration(milliseconds: 900);      // 스플래시 유지 시간
    static const _transition = Duration(milliseconds: 280); // 전환 페이드 시간

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
        );
        _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
        _controller.forward();

        // 일정 시간 뒤 NavShell로 교체
        Future.delayed(_hold, () {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const NavShell(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: _transition,
                ),
            );
        });
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final bg = Theme.of(context).colorScheme.surface; // 테마 배경과 일치
        return Scaffold(
            backgroundColor: bg,
            body: FadeTransition(
                opacity: _fade,
                child: Center(
                    child: Image.asset(
                        'assets/images/logo.png', // 현재 경로 그대로 사용
                        width: 160,
                        fit: BoxFit.contain,
                    ),
                ),
            ),
        );
    }
}
