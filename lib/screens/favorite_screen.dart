import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String selectedPage = "Yêu thích";
  int currentIndex = 3;
  int selectedIndex = 3;

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  List<Map<String, dynamic>> likedProducts = [
    {
      'image': 'lib/assets/images/product_1.png',
      'name': 'Áo thun dry cổ tròn',
      'desc': 'Chất vải thoáng mát',
      'price': 300000,
      'liked': true,
    },
    {
      'image': 'lib/assets/images/product_2.png',
      'name': 'Áo thun TS-2',
      'desc': 'Chất vải thoáng mát',
      'price': 250000,
      'liked': true,
    },
    {
      'image': 'lib/assets/images/product_3.png',
      'name': 'Áo thun cổ tròn dài tay',
      'desc': 'Chất vải thoáng mát',
      'price': 390000,
      'liked': true,
    },
    {
      'image': 'lib/assets/images/product_4.png',
      'name': 'Áo thun TS-3',
      'desc': 'Chất vải thoáng mát',
      'price': 250000,
      'liked': true,
    },
    {
      'image': 'lib/assets/images/product_5.png',
      'name': 'Áo thun TS-4',
      'desc': 'Chất vải thoáng mát',
      'price': 400000,
      'liked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return likedProducts.isEmpty
        ? Scaffold(
          backgroundColor: Colors.white,
          drawer: CustomDrawer(
            selectedPage: selectedPage,
            onSelect: (String newPage) {
              setState(() {
                selectedPage = newPage;
              });
              Navigator.pop(context);
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Header(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "YÊU THÍCH",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "TenorSans",
                          ),
                        ),
                        Devider(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 60,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffF2E5DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.heart_broken_rounded,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Bạn chưa có sản phẩm\nyêu thích nào!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "NotoSerif_2",
                              color: Color(0xff333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        )
        : Scaffold(
          backgroundColor: Colors.white,
          drawer: CustomDrawer(
            selectedPage: "",
            onSelect: (selected) {
              smoothPushReplacementLikePush(
                context,
                getPageFromLabel(selected),
              );
            },
          ),
          body: SafeArea(
            child: Column(
              children: [
                Header(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "YÊU THÍCH",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "TenorSans",
                          ),
                        ),
                        Devider(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: likedProducts.length,
                    itemBuilder: (context, index) {
                      final item = likedProducts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF2E5DF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    item['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['desc'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${formatCurrency(item['price'])}",
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.add_shopping_cart,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Thêm vào giỏ hàng",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        likedProducts[index]['liked'] =
                                            !likedProducts[index]['liked'];
                                      });
                                    },
                                    child: Icon(
                                      likedProducts[index]['liked']
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          likedProducts[index]['liked']
                                              ? Colors.orange
                                              : Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        );
  }
}
