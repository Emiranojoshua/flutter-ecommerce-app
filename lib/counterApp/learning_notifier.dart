import 'package:ecommerce_app/counterApp/new_app.dart';
import 'package:ecommerce_app/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LearningNotifier extends StatelessWidget {
  const LearningNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: const NewApp(),
      create: (context) => CounterProvider(),
    );
  }
}
