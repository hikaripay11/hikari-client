// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'design_system/theme.dart';
import 'features/home/home_view.dart';
import 'widgets/pill_navbar.dart';
import 'features/menu/menu_view.dart';

// ▼ settings
import 'core/models/app_settings.dart';
import 'features/settings/controllers/settings_controller.dart';

class HikariApp extends ConsumerWidget {
    const HikariApp({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final settingsAsync = ref.watch(settingsProvider);
        final settings = settingsAsync.value ?? AppSettings.defaultValue;

        return MaterialApp(
            title: 'Hikari',
            debugShowCheckedModeBanner: false,

            // ▼ 테마 (기존 유지)
            theme: hikariTheme(Brightness.light),
            darkTheme: hikariTheme(Brightness.dark),

            // ▼ 국제화 (지금은 기본 델리게이트만, gen-l10n 붙이면 여기 확장)
            supportedLocales: const [Locale('en'), Locale('ja'), Locale('ko')],
            locale: settings.locale,
            localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
            ],

            // ▼ 시스템 전역 텍스트 스케일 적용
            builder: (context, child) {
                final mq = MediaQuery.of(context);
                return MediaQuery(
                    data: mq.copyWith(
                        textScaler: TextScaler.linear(settings.textScale),
                    ),
                    child: child!,
                );
            },

            home: const NavShell(), // ✅ 기존 시작 화면 유지
        );
    }
}

class NavShell extends StatefulWidget {
    const NavShell({super.key});

    @override
    State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
    int _index = 0;

    final _pages = const [
        HomeView(),
        Placeholder(),
        Placeholder(),
        MenuView(),
    ];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            extendBody: true,
            body: IndexedStack(index: _index, children: _pages),
            bottomNavigationBar: PillNavBar(
                currentIndex: _index,
                onTap: (i) => setState(() => _index = i),
            ),
        );
    }
}
