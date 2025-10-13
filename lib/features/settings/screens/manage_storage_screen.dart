import 'package:flutter/material.dart';

class ManageStorageScreen extends StatelessWidget {
    const ManageStorageScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('Manage Storage')),
            body: const Center(child: Text('Cache size, clear cache, downloads (TBD)')),
        );
    }
}
