import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/screens/product_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/home_banner.dart';
import 'package:the4m_app/widgets/title.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/similar_product.dart';
import 'package:video_player/video_player.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the4m_app/models/product.dart';
//models

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPage = "Trang chủ";

  final List<String> categories = ['Tất cả', 'Áo', 'Quần', 'Nón'];

  int currentIndex = 0;
  int selectedIndex = 0;

  final List<String> brands = [
    'lib/assets/images/brand_1.png',
    'lib/assets/images/brand_2.png',
    'lib/assets/images/brand_3.png',
    'lib/assets/images/brand_4.png',
    'lib/assets/images/brand_5.png',
    'lib/assets/images/brand_6.png',
  ];

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'lib/assets/videos/home_video.mp4',
      )
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final childAspectRatio = (screenWidth / crossAxisCount) / 300;
    return Scaffold(
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HomeBanner(),
                    SizedBox(height: 40),
                    TitleWithDivider(title: 'MỚI NHẤT'),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(categories.length, (index) {
                          bool isActive = currentIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    categories[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          isActive
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isActive
                                              ? Colors.black
                                              : Color(0xff888888),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          isActive
                                              ? Color(0xffDD8560)
                                              : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 5),
                    //danh muc san pham
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('SanPham')
                              .where(
                                'ngayNhapSP',
                                isGreaterThanOrEqualTo: Timestamp.fromDate(
                                  DateTime.now().subtract(Duration(days: 100)),
                                ),
                              )
                              .orderBy('ngayNhapSP', descending: true)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("Không có sản phẩm gần đây"),
                          );
                        }

                        List<Product> allProducts =
                            snapshot.data!.docs.map((doc) {
                              return Product.fromMap(
                                doc.data() as Map<String, dynamic>,
                                doc.id,
                              );
                            }).toList();

                        // Lọc theo danh mục
                        String selectedCategory = categories[currentIndex];
                        List<Product> filteredProducts =
                            selectedCategory == 'Tất cả'
                                ? allProducts
                                : allProducts
                                    .where(
                                      (p) =>
                                          p.loaiSPTQ.toLowerCase() ==
                                          selectedCategory.toLowerCase(),
                                    )
                                    .toList();

                        // Giới hạn hiển thị 10 sản phẩm
                        final limitedProducts =
                            filteredProducts.take(10).toList();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            itemCount: limitedProducts.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemBuilder: (context, index) {
                              final product = limitedProducts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductDetailScreen(
                                            product: product,
                                          ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.asset(
                                          product.hinhAnh.isNotEmpty
                                              ? product.hinhAnh[0]
                                              : '',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => const Icon(
                                                Icons.broken_image,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: Text(
                                        product.tenSP,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${formatCurrency(product.giaMoi)}",
                                      style: const TextStyle(
                                        color: Color(0xffDD8560),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          smoothPushReplacementLikePush(
                            context,
                            ProductScreen(),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'KHÁM PHÁ THÊM',
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 15,
                                fontFamily: 'TenorSans',
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_right_alt,
                              color: Colors.black,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Devider(),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        itemCount: brands.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 40,
                          mainAxisSpacing: 25,
                          childAspectRatio: 2.6,
                        ),
                        itemBuilder: (context, index) {
                          return Image.asset(brands[index], fit: BoxFit.cover);
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Devider(),
                    SizedBox(height: 40),
                    Stack(
                      children: [
                        _controller.value.isInitialized
                            ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                            : CircularProgressIndicator(),
                        Positioned.fill(
                          child: Center(
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              backgroundColor:
                                  _controller.value.isPlaying
                                      ? Colors.transparent
                                      : Colors.grey.withOpacity(0.2),
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Color(0xffDD9560),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    TitleWithDivider(title: 'DÀNH CHO BẠN'),
                    SizedBox(height: 20),
                    SimilarProduct(),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        Text(
                          '@TOP TRENDING',
                          style: TextStyle(fontSize: 20, letterSpacing: 4.0),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /*Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '#2025',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),*/
                            Text('#2025'),
                            Text('#aopolo'),
                            Text('#aopolo'),
                            Text('#non'),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('#quanthun'),
                            Text('#quanjean'),
                            Text('#aokhoac'),
                            Text('#boss'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                '4&M',
                                style: TextStyle(
                                  fontFamily: 'Sriracha',
                                  fontSize: 36,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Mang phong cách sống đẳng cấp đến gần\nhơn với mọi quý ông hiện đại là nguồn\ncảm hứng mỗi ngày của chúng tôi.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xff333333)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Devider(),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              Image.asset(
                                'lib/assets/images/home_ic1.png',
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Giao hàng nhanh chóng và miễn phí',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              Image.asset(
                                'lib/assets/images/home_ic2.png',
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sản phẩm thân thiện môi trường',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              Image.asset(
                                'lib/assets/images/home_ic3.png',
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sản phẩm thiết kế lịch lãm và sang trọng',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              Image.asset(
                                'lib/assets/images/home_ic4.png',
                                width: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dễ dàng đổi trả sản phẩm 24/7',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'lib/assets/images/home_ic5.png',
                        width: 70,
                      ),
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                'THEO DÕI',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 4.0,
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'lib/assets/images/instagram.png',
                                  width: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            buildInstagramItem(
                              'lib/assets/images/instagram_1.png',
                              '@_Thang',
                            ),
                            buildInstagramItem(
                              'lib/assets/images/instagram_2.png',
                              '@_Tin',
                            ),
                            buildInstagramItem(
                              'lib/assets/images/instagram_3.png',
                              '@_Phuoc',
                            ),
                            buildInstagramItem(
                              'lib/assets/images/instagram_4.png',
                              '@_Khoa',
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        //footer
                        Footer(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ],
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
    );
  }
}

Widget buildInstagramItem(String imagePath, String username) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 150,
          height: 150,
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
      Positioned(
        bottom: 8,
        left: 8,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          color: Colors.black.withOpacity(0.6),
          child: Text(
            username,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ),
    ],
  );
}
