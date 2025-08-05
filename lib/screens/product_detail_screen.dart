import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/contact_screen.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/utils/app_colors.dart';
import 'package:the4m_app/models/review_model.dart';
import 'package:the4m_app/widgets/review_item.dart';
import 'package:the4m_app/widgets/product_item.dart';
import 'package:the4m_app/widgets/cart_notify.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = new PageController();
  int _currentPage = 0;
  int selectedPage = 0;
  String selectedColor = '';
  String selectedSize = '';
  List<String> availableColors = [];
  List<String> availableSizes = [];

  bool isDeliveryExpanded = false;
  bool isReturnExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchVariants();
  }

  List<Map<String, dynamic>> allVariants = [];

  Future<void> fetchVariants() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('SanPham')
            .doc(widget.product.maSP)
            .collection('bienThe')
            .get();

    allVariants =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'mauSac': data['mauSac'] ?? '',
            'kichThuoc': data['kichThuoc'] ?? '',
            'soLuong': data['soLuong'] ?? 0,
          };
        }).toList();

    final colors =
        allVariants.map((v) => v['mauSac'] as String).toSet().toList();

    setState(() {
      availableColors = colors;
      selectedColor = availableColors.isNotEmpty ? availableColors[0] : '';
      availableSizes = getSizesForColor(selectedColor);
      selectedSize = availableSizes.isNotEmpty ? availableSizes[0] : '';
    });
  }

  List<String> sizeOrder = [
    "S",
    "M",
    "L",
    "XL",
    "XXL",
    "29",
    "30",
    "31",
    "32",
    "Free Size",
  ];

  List<String> getSizesForColor(String color) {
    List<String> sizes =
        allVariants
            .where((v) => v['mauSac'] == color)
            .map((v) => v['kichThuoc'] as String)
            .toSet()
            .toList();

    // Sắp xếp theo thứ tự sizeOrder
    sizes.sort((a, b) {
      int indexA = sizeOrder.indexOf(a);
      int indexB = sizeOrder.indexOf(b);
      // nếu không có trong danh sách mặc định thì đặt cuối
      if (indexA == -1) indexA = 999;
      if (indexB == -1) indexB = 999;
      return indexA.compareTo(indexB);
    });

    return sizes;
  }

  Color getColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'đen':
        return Color(0xff0D0D0D);
      case 'trắng':
        return Color(0xffF6F6E7);
      case 'xám':
        return Color(0xff555555);
      case 'nâu':
        return Color(0xffCEC2AA);
      case 'xanh navy':
        return Color(0xff1E3F5A);
      case 'be':
        return Color(0xffFFDD95);
      case 'cam':
        return Color(0xffFFA600);
      case 'xanh lá':
        return Color(0xff288A28);
      default:
        return Color(0xff0D0D0D);
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

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

  Future<void> addToCart() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Vui lòng đăng nhập để tiếp tục mua hàng"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final variantQuery =
          await FirebaseFirestore.instance
              .collection('SanPham')
              .doc(widget.product.maSP)
              .collection('bienThe')
              .where('mauSac', isEqualTo: selectedColor)
              .where('kichThuoc', isEqualTo: selectedSize)
              .limit(1)
              .get();

      if (variantQuery.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Biến thể này hiện không tồn tại"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final variantDoc = variantQuery.docs.first;
      final stock = variantDoc['soLuong'] ?? 0;

      if (stock <= 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Sản phẩm đã hết hàng")));
        return;
      }

      final cartItem = Cart(
        id: "",
        maSP: widget.product.maSP,
        tenSP: widget.product.tenSP,
        hinhAnh: widget.product.hinhAnh[0],
        gia: widget.product.giaMoi,
        kichThuoc: selectedSize,
        mauSac: selectedColor,
        soLuong: 1,
      );

      final cartRef = FirebaseFirestore.instance
          .collection('TaiKhoan')
          .doc(currentUser.uid)
          .collection("GioHang");

      final existing =
          await cartRef
              .where('maSP', isEqualTo: cartItem.maSP)
              .where('kichThuoc', isEqualTo: cartItem.kichThuoc)
              .where('mauSac', isEqualTo: cartItem.mauSac)
              .get();

      if (existing.docs.isNotEmpty) {
        final doc = existing.docs.first;
        final currentQuantity = doc['soLuong'] ?? 0;

        if (currentQuantity >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Bạn chỉ được mua tối đa 5 sản phẩm cho biến thể này",
              ),
            ),
          );
          return;
        }

        await cartRef.doc(doc.id).update({'soLuong': currentQuantity + 1});
      } else {
        final docRef = await cartRef.add(cartItem.toMap());
        await docRef.update({"id": docRef.id});
      }

      cartNotify.increment();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Thêm sản phẩm thành công!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final earliest = now.add(Duration(days: 3));
    final latest = now.add(Duration(days: 5));
    final dateFormat = DateFormat('dd/MM/yyyy');

    final reviews = getSampleReviews();
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: "",
        onSelect: (selected) {
          smoothPushReplacementLikePush(context, getPageFromLabel(selected));
        },
      ),
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
                        itemCount: widget.product.hinhAnh.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            widget.product.hinhAnh[index],
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
                      children: List.generate(widget.product.hinhAnh.length, (
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
                            widget.product.tenSP +
                                " - " +
                                widget.product.thuongHieu,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "TenorSans",
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "${formatCurrency(widget.product.giaMoi)}",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.orange,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Màu sắc:",
                                    style: TextStyle(fontFamily: "TenorSans"),
                                  ),
                                  const SizedBox(width: 5),
                                  if (availableColors.isEmpty)
                                    const Text(
                                      "Không có màu",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  else
                                    ...availableColors.map(
                                      (color) => GestureDetector(
                                        onTap:
                                            () => setState(() {
                                              selectedColor = color;
                                              availableSizes = getSizesForColor(
                                                color,
                                              );
                                              selectedSize =
                                                  availableSizes.isNotEmpty
                                                      ? availableSizes[0]
                                                      : '';
                                            }),
                                        child: ColorButton(
                                          getColorFromName(color),
                                          isSelected: selectedColor == color,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Kích cỡ:",
                                    style: TextStyle(fontFamily: "TenorSans"),
                                  ),
                                  const SizedBox(width: 5),
                                  if (availableSizes.isEmpty)
                                    const Text(
                                      "Không có size",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  else
                                    ...availableSizes.map(
                                      (size) => GestureDetector(
                                        onTap:
                                            () => setState(
                                              () => selectedSize = size,
                                            ),
                                        child: SizeButton(
                                          size,
                                          isSelected: selectedSize == size,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //Nut them san pham
                    GestureDetector(
                      onTap: () => addToCart(),
                      child: Container(
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
                            widget.product.chatLieu,
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
                            widget.product.baoQuan,
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
                                widget.product.thuocTay,
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
                                widget.product.giatKho,
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
                                widget.product.sayKho,
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
                                widget.product.nhietDoUi,
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
                                      "${dateFormat.format(earliest)} - ${dateFormat.format(latest)}",
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
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                            StreamBuilder(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('SanPham')
                                      .where(
                                        'loaiSP',
                                        isEqualTo: widget.product.loaiSP,
                                      )
                                      .limit(4)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text("Không có sản phẩm tương tự");
                                }

                                final similarProducts =
                                    snapshot.data!.docs
                                        .map(
                                          (doc) => Product.fromMap(
                                            doc.data() as Map<String, dynamic>,
                                            doc.id,
                                          ),
                                        )
                                        .where(
                                          (product) =>
                                              product.maSP !=
                                              widget.product.maSP,
                                        )
                                        .toList();

                                return GridView.builder(
                                  itemCount: similarProducts.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.7,
                                      ),
                                  itemBuilder: (context, index) {
                                    return ProductItem(
                                      product: similarProducts[index],
                                    );
                                  },
                                );
                              },
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xff333333) : Colors.white,
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        color: isSelected ? const Color(0xff333333) : const Color(0xff555555),
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

Widget getPageFromLabel(String label) {
  switch (label) {
    case "Trang chủ":
      return HomeScreen();
    case "Yêu thích":
      return FavoriteScreen();
    case "Tài khoản":
      return Account_Screen();
    case "Thông tin":
      return OurStoryScreen();
    case "Liên lạc":
      return ContactScreen();
    case "Blog":
      return BlogScreen();
    default:
      return HomeScreen();
  }
}
