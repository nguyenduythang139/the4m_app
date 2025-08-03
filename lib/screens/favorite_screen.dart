import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/cart_notify.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String selectedPage = "Yêu thích";
  int currentIndex = 3;
  int selectedIndex = 3;

  String formatCurrency(dynamic amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    if (amount == null) return formatter.format(0);

    if (amount is int || amount is double) {
      return formatter.format(amount);
    }

    // Nếu là String có thể chuyển sang số
    if (amount is String) {
      final parsed = num.tryParse(amount);
      return formatter.format(parsed ?? 0);
    }

    // Nếu kiểu không hỗ trợ, trả 0
    return formatter.format(0);
  }

  // List<Map<String, dynamic>> likedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  List<Product> likedProducts = [];

  Future<void> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('TaiKhoan')
            .doc(user.uid)
            .collection('YeuThich')
            .get();

    setState(() {
      likedProducts =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Product(
              maSP: data['maSP'],
              tenSP: data['tenSP'],
              giaCu: data['giaCu'],
              giaMoi: data['giaMoi'],
              moTa: data['moTa'],
              hinhAnh: List<String>.from(data['hinhAnh']),
              mauSac: List<String>.from(data['mauSac']),
              kichThuoc: List<String>.from(data['kichThuoc']),
              loaiSP: data['loaiSP'],
              thuongHieu: data['thuongHieu'],
              chatLieu: data['chatLieu'],
              baoQuan: data['baoQuan'],
              thuocTay: data['thuocTay'],
              giatKho: data['giatKho'],
              sayKho: data['sayKho'],
              nhietDoUi: data['nhietDoUi'],
              loaiSPTQ: data['loaiSPTQ'],
              liked: true,
            );
          }).toList();
    });
  }

  Future<void> removeFromFavorites(String maSP, int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('TaiKhoan')
            .doc(user.uid)
            .collection('YeuThich')
            .where('maSP', isEqualTo: maSP)
            .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      likedProducts.removeAt(index);
    });
  }

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
                      final product = likedProducts[index];
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
                                    product.hinhAnh[0],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.image_not_supported),
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
                                        product.tenSP,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.moTa,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${formatCurrency(product.giaMoi)}",
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 14,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      ProductDetailScreen(
                                                        product: product,
                                                      ),
                                            ),
                                          );
                                        },
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
                                    onTap: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: Text(
                                                'Xóa khỏi yêu thích?',
                                              ),
                                              content: Text(
                                                'Bạn có chắc chắn muốn xóa sản phẩm này khỏi danh sách yêu thích không?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: Text('Hủy'),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: Text('Xóa'),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (confirm == true) {
                                        removeFromFavorites(
                                          product.maSP,
                                          index,
                                        );
                                      }
                                    },
                                    child: Icon(
                                      product.liked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          product.liked
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
