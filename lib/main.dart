import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  // Riverpod 루트
  runApp(const ProviderScope(child: HikariApp()));
}
