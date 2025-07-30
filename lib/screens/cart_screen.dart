import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/contact_screen.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/screens/payment_screen.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/screens/voucher_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/cart_item.dart';
import 'package:the4m_app/widgets/cart_notify.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> cartList = [];

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  Future<void> fetchCartData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('TaiKhoan')
            .doc(user.uid)
            .collection('GioHang')
            .get();

    final items =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return Cart(
            id: doc.id,
            maSP: data['maSP'],
            tenSP: data['tenSP'],
            hinhAnh: data['hinhAnh'],
            gia: data['gia'],
            kichThuoc: data['kichThuoc'],
            mauSac: data['mauSac'],
            soLuong: data['soLuong'],
          );
        }).toList();

    setState(() {
      cartList = items;
    });

    cartNotify.updateCount(calculateQuantity());
  }

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  int calculateTotal() {
    return cartList.fold(0, (sum, item) => sum + item.gia * item.soLuong);
  }

  int calculateQuantity() {
    return cartList.fold(0, (sum, item) => sum + item.soLuong);
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "GIỎ HÀNG",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "TenorSans",
                          ),
                        ),
                        Devider(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        smoothPushReplacementLikePush(context, HomeScreen());
                      },
                      child: Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  cartList.isEmpty
                      ? Center(child: Text("Giỏ hàng của bạn đang trống"))
                      : ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          return CartItem(
                            cart: cartList[index],
                            onRemove: () {
                              setState(() {
                                cartList.removeAt(index);
                                cartNotify.updateCount(calculateQuantity());
                              });
                            },
                            onQuantityChange: (newQuantity) {
                              setState(() {
                                cartList[index].soLuong = newQuantity;
                                cartNotify.updateCount(calculateQuantity());
                              });
                            },
                          );
                        },
                      ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("TỔNG ĐƠN HÀNG | ${calculateQuantity()} SẢN PHẨM"),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng cộng"),
                        Text(
                          formatCurrency(calculateTotal()),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Phiếu giảm giá"), Text("- 0 VNĐ")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã bao gồm thuế"),
                        Text(formatCurrency((calculateTotal() * 0.1).toInt())),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "THÀNH TIỀN:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatCurrency((calculateTotal() * 1.1).toInt()),
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoucherScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.confirmation_num),
                          SizedBox(width: 10),
                          Text("PHIẾU GIẢM GIÁ"),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentScreen()),
            );
          },
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            "THANH TOÁN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "TenorSans",
            ),
          ),
        ),
      ),
    );
  }
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
