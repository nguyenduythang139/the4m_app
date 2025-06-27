import 'package:flutter/material.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/utils/app_colors.dart';
import 'package:the4m_app/models/review_model.dart';
import 'package:the4m_app/widgets/review_item.dart';
import 'package:the4m_app/models/product_model.dart';
import 'package:the4m_app/widgets/product_item.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = new PageController();
  int _currentPage = 0;
  int selectedPage = 0;

  bool isDeliveryExpanded = false;
  bool isReturnExpanded = false;

  final List<String> productDetailImages = [
    'lib/asset/images/product_detail_1',
    'lib/asset/images/product_detail_2',
    'lib/asset/images/product_detail_3',
    'lib/asset/images/product_detail_1',
    'lib/asset/images/product_detail_2',
  ];

  List<Review> getSampleReviews() {
    return [
      Review(
        title: "Sản phẩm tuyệt vời!",
        date: "2026-06-23",
        rating: 5,
        size: "M",
        color: "Đen",
        content: "Giá cả phải chăng, chất vải thoáng mát.",
        userName: "Thắng Nguyễn",
        avatarUrl: "lib/assets/images/instagram_1.png",
      ),
      Review(
        title: "Sản phẩm đúng như mô tả",
        date: "2026-06-20",
        rating: 4,
        size: "L",
        color: "Trắng",
        content: "Chất lượng vải tốt như mô tả.",
        userName: "Phước Nguyễn",
        avatarUrl: "lib/assets/images/instagram_3.png",
      ),
      Review(
        title: "Trên cả mong đợi của tôi",
        date: "2026-06-19",
        rating: 4,
        size: "M",
        color: "Xanh",
        content: "Chất vải thoáng mát, mịn màng và thiết kế đẹp mắt.",
        userName: "Tín Lữ",
        avatarUrl: "lib/assets/images/instagram_2.png",
      ),
    ];
  }

  List<Products> getSampleProducts() {
    return [
      Products(
        name: "Áo thun dáng rộng",
        imageUrl: "lib/assets/images/product_1.png",
        price: 300000,
        isFavorite: true,
      ),
      Products(
        name: "Áo thun dáng rộng",
        imageUrl: "lib/assets/images/product_2.png",
        price: 300000,
        isFavorite: true,
      ),
      Products(
        name: "Áo thun dáng rộng",
        imageUrl: "lib/assets/images/product_5.png",
        price: 300000,
        isFavorite: true,
      ),
      Products(
        name: "Áo thun dáng rộng",
        imageUrl: "lib/assets/images/product_4.png",
        price: 300000,
        isFavorite: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final reviews = getSampleReviews();
    final products = getSampleProducts();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Anh chi tiet san pham
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: productDetailImages.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            productDetailImages[index],
                            fit: BoxFit.cover,
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(productDetailImages.length, (
                        index,
                      ) {
                        bool isActive = _currentPage == index;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          width: isActive ? 12 : 10,
                          height: isActive ? 12 : 10,
                          child: Transform.rotate(
                            angle: 0.785398,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isActive ? Colors.grey : Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    //Thong tin tong quat
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Áo Thun Dry Cổ Tròn Nhiều Màu',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "TenorSans",
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '300.000 VNĐ',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.orange,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Màu:',
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                              SizedBox(width: 8),
                              Row(
                                children: [
                                  ColorButton(Colors.black, isSelected: true),
                                  ColorButton(Colors.orange),
                                  ColorButton(Colors.brown),
                                ],
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Kích cỡ:',
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                              SizedBox(width: 8),
                              Row(
                                children: [
                                  SizeButton('S', isSelected: true),
                                  SizeButton('L'),
                                  SizeButton('M'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //Nut them san pham
                    Container(
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 18),
                              SizedBox(width: 10),
                              Text(
                                "THÊM VÀO GIỎ HÀNG",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "TenorSans",
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //Thong tin chi tiet
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CHẤT LIỆU",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "TenorSans",
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "- Vải pha cotton và polyester với công nghệ DRY nhanh khô.\n- Cổ tròn cổ điển.\n- Kiểu dáng cơ bản, phù hợp để mặc riêng lẻ hoặc như một lớp áo bên trong.",
                            style: TextStyle(fontFamily: "TenorSans"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "BẢO QUẢN",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "TenorSans",
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "- Giặt máy nước lạnh\n- Không giặt khô\n- Không sấy khô",
                            style: TextStyle(fontFamily: "TenorSans"),
                          ),
                          SizedBox(height: 20),
                          //Thong tin thuoc tay
                          Row(
                            children: [
                              Image.asset(
                                "lib/assets/images/khongthuoctay.png",
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Không dùng thuốc tấy",
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Thong tin giat
                          Row(
                            children: [
                              Image.asset("lib/assets/images/khonggiatkho.png"),
                              SizedBox(width: 10),
                              Text(
                                "Không giặt khô",
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Thong tin say
                          Row(
                            children: [
                              Image.asset("lib/assets/images/khongsaykho.png"),
                              SizedBox(width: 10),
                              Text(
                                "Không sấy khô",
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Thong tin nhiet do ui
                          Row(
                            children: [
                              Image.asset("lib/assets/images/nhietdoui.png"),
                              SizedBox(width: 10),
                              Text(
                                "Ủi ở nhiệt độ tối đa 110ºC/230ºF",
                                style: TextStyle(fontFamily: "TenorSans"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Dich vu
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DỊCH VỤ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "TenorSans",
                            ),
                          ),
                          SizedBox(height: 10),
                          ExpansionTile(
                            leading: Icon(
                              Icons.local_shipping_outlined,
                              color:
                                  isDeliveryExpanded
                                      ? AppColors.orange
                                      : Colors.black,
                            ),
                            title: Text(
                              "Miễn phí giao hàng!",
                              style: TextStyle(
                                color:
                                    isDeliveryExpanded
                                        ? AppColors.orange
                                        : Colors.black,
                                fontFamily: "TenorSans",
                              ),
                            ),
                            trailing: Icon(
                              isDeliveryExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color:
                                  isDeliveryExpanded
                                      ? AppColors.orange
                                      : Colors.black,
                            ),
                            childrenPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dự kiến ngày được giao chậm nhất",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "TenorSans",
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "08/06/2025 - 12/06/2025.",
                                      style: TextStyle(fontFamily: "TenorSans"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onExpansionChanged: (expanded) {
                              setState(() {
                                isDeliveryExpanded = !isDeliveryExpanded;
                              });
                            },
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(0xFFBDBDBD),
                          ),
                          ExpansionTile(
                            leading: Icon(
                              Icons.sync_alt,
                              color:
                                  isReturnExpanded
                                      ? AppColors.orange
                                      : Colors.black,
                            ),
                            title: Text(
                              "Chính sách đổi trả",
                              style: TextStyle(
                                color:
                                    isReturnExpanded
                                        ? AppColors.orange
                                        : Colors.black,
                                fontFamily: "TenorSans",
                              ),
                            ),
                            trailing: Icon(
                              isReturnExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color:
                                  isReturnExpanded
                                      ? AppColors.orange
                                      : Colors.black,
                            ),
                            childrenPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Sản phẩm được đổi trả trong vòng 15 ngày kể từ ngày nhận hàng.",
                                  style: TextStyle(fontFamily: "TenorSans"),
                                ),
                              ),
                            ],
                            onExpansionChanged: (expanded) {
                              setState(() {
                                isReturnExpanded = !isReturnExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Danh gia san pham
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ĐÁNH GIÁ SẢN PHẨM",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "TenorSans",
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text("5.0"),
                              SizedBox(width: 4),
                              Text(
                                "(${reviews.length})",
                                style: const TextStyle(color: Colors.pink),
                              ),
                            ],
                          ),
                          Divider(height: 30),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 375,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...reviews
                                .map((review) => ReviewItem(review: review))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              "SẢN PHẨM TƯƠNG TỰ",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "TenorSans",
                              ),
                            ),
                            SizedBox(height: 2),
                            Devider(),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 500,
                              child: GridView.builder(
                                itemCount: products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.7,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductItem(product: products[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}

Widget ColorButton(Color color, {bool isSelected = false}) {
  return Container(
    padding: EdgeInsets.all(2),
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? Color(0xff555555) : Colors.white,
        width: 1,
      ),
      shape: BoxShape.circle,
    ),
    child: Align(
      alignment: Alignment.center,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

Widget SizeButton(String size, {bool isSelected = false}) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    width: 26,
    height: 26,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isSelected ? Color(0xff333333) : Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: isSelected ? Color(0xff333333) : Color(0xff555555),
      ),
    ),
    child: Text(
      size,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
