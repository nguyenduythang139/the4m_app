import 'package:flutter/material.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/account_screen.dart';

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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      case 1:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SearchScreen()),
      // );
      // break;
      case 2:
      //  Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => const HomeScreen()),
      //       (route) => false,
      //     );
      case 3:
      //  Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => const HomeScreen()),
      //         (route) => false,
      //       );
      case 4:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Account_Screen()),
          (route) => false,
        );
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
