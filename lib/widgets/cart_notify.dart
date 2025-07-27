import 'package:flutter/material.dart';

class CartNotify extends ValueNotifier<int> {
  CartNotify() : super(0);

  void updateCount(int count) {
    value = count;
  }

  void increment() {
    value++;
  }

  void decrement() {
    if (value > 0) value--;
  }
}

final cartNotify = CartNotify();
