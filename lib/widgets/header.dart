import 'package:flutter/material.dart';
import 'package:the4m_app/screens/cart_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/cart_notify.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
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
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  iconSize: 30,
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    smoothPushReplacementLikePush(context, CartScreen());
                  },
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: ValueListenableBuilder(
                          valueListenable: cartNotify,
                          builder: (context, value, child) {
                            if (value == 0) return SizedBox();
                            return Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
