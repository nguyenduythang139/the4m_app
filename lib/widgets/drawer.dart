import 'package:flutter/material.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/contact_screen.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/myinfo_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/screens/product_screen.dart';

class CustomDrawer extends StatefulWidget {
  final String selectedPage;
  final Function(String) onSelect;

  const CustomDrawer({
    super.key,
    required this.selectedPage,
    required this.onSelect,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLight = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thong tin nguoi dung
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('lib/assets/images/avatar.png'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phuoc Nguyen',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('phuocnguyen@gmail.com'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // Menu
            drawerItem(context, Icons.home, "Trang chủ", HomeScreen()),
            drawerItem(context, Icons.search, "Tìm kiếm", HomeScreen()),
            drawerItem(
              context,
              Icons.shopping_bag_outlined,
              "Mua sắm",
              ProductScreen(),
            ),
            drawerItem(
              context,
              Icons.favorite_border,
              "Yêu thích",
              FavoriteScreen(),
            ),
            drawerItem(
              context,
              Icons.person_outline,
              "Tài khoản",
              Account_Screen(),
            ),
            drawerItem(
              context,
              Icons.info_outline,
              "Thông tin",
              OurStoryScreen(),
            ),
            drawerItem(
              context,
              Icons.contact_page_outlined,
              "Liên lạc",
              ContactScreen(),
            ),
            drawerItem(context, Icons.edit_note_outlined, "Blog", BlogScreen()),
            Spacer(),
            // Che do trang - den
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xffd5d5d5),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Che do sang
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLight = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isLight ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.light_mode,
                              size: 18,
                              color: isLight ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Sáng',
                              style: TextStyle(
                                color: isLight ? Colors.black : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Che do toi
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLight = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !isLight ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              size: 18,
                              color: !isLight ? Colors.black : Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tối',
                              style: TextStyle(
                                color: !isLight ? Colors.black : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
    BuildContext context,
    IconData icon,
    String label,
    Widget page,
  ) {
    final bool isActive = widget.selectedPage == label;

    return GestureDetector(
      onTap: () {
        widget.onSelect(label);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? Color(0xffd5d5d5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 15),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
