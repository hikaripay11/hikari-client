// lib/app.dart
import 'package:flutter/material.dart';
import 'design_system/theme.dart';
import 'features/home/home_view.dart';
import 'widgets/pill_navbar.dart';
import 'features/menu/menu_view.dart';

class HikariApp extends StatelessWidget {
    const HikariApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Hikari',
            debugShowCheckedModeBanner: false,
            theme: hikariTheme(Brightness.light),
            darkTheme: hikariTheme(Brightness.dark),
            home: const NavShell(), // ✅ 바로 메인 탭으로
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
