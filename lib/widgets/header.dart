import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80); // Tăng để chứa padding top

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80, // Tăng chiều cao để không bị chật
      padding: const EdgeInsets.only(
        top: 20,
        left: 10,
        right: 10,
      ), // Top + giữ nguyên left/right
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                // TODO: Thêm chức năng menu nếu cần
              },
              icon: const Icon(Icons.menu),
              iconSize: 30,
              color: Colors.black,
            ),
          ),
          const Center(
            child: Text(
              '4&M',
              style: TextStyle(
                fontFamily: 'Sriracha',
                fontSize: 36,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Thêm chức năng tìm kiếm
                  },
                  icon: const Icon(Icons.search),
                  iconSize: 30,
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Thêm chức năng giỏ hàng
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  iconSize: 30,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
