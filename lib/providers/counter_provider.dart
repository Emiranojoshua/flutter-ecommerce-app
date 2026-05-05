import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment(int value) {
    _counter += value;
    notifyListeners();
  }

  void decrement(int value) {
    _counter -= value;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    notifyListeners();
  }
}