import 'package:paddy_health/widgets/take_pic.dart';
import 'package:paddy_health/dependencies/tfl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paddy health',
      theme: ThemeData(
        textTheme: Typography.blackMountainView.apply(fontFamily: 'Lato'),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF95C19E)),
        useMaterial3: true,
      ),
      home: const EagerInitTFL(
        child: TakePicScreen(),
      ),
    );
  }
}
