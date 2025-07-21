import 'package:flutter/material.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/myinfo_screen.dart';
import 'package:the4m_app/screens/product_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        smoothPushReplacementLikePush(context, HomeScreen());
      //case 1:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SearchScreen()),
      // );
      // break;
      case 2:
        smoothPushReplacementLikePush(context, ProductScreen());
      case 3:
        smoothPushReplacementLikePush(context, FavoriteScreen());
      case 4:
        smoothPushReplacementLikePush(context, Account_Screen());
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black.withOpacity(0.7),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      currentIndex: currentIndex,
      onTap: (index) {
        onTap(index); // Callback nếu cần cập nhật state tại bên ngoài
        _navigateToScreen(context, index);
      },
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
