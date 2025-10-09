import 'package:flutter/material.dart';

void main() => runApp(const HikariApp());

class HikariApp extends StatelessWidget {
  const HikariApp({super.key});

  @override
  Widget build(BuildContext context) {
    final light = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B8CFF),
      brightness: Brightness.light,
    );
    final dark = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B8CFF),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Hikari',
      theme: ThemeData(colorScheme: light, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: dark, useMaterial3: true),
      home: const SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 96, height: 96),
            const SizedBox(height: 16),
            const Text('Hikari', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Welcome to Hikari 👋'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: const Text('New Transfer'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Transaction History'),
            ),
          ],
        ),
      ),
    );
  }
}
