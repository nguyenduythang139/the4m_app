import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {},
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
                  onPressed: () {},
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
