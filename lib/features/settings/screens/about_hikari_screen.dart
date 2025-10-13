import 'package:flutter/material.dart';

class AboutHikariScreen extends StatelessWidget {
    const AboutHikariScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('About Hikari')),
            body: const Center(child: Text('App info, team, acknowledgements (TBD)')),
        );
    }
}
