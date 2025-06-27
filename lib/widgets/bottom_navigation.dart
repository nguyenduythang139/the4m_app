import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black.withOpacity(0.7),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Mua sắm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
