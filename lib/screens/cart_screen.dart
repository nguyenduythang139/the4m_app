import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:the4m_app/models/voucher.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/contact_screen.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/screens/payment_screen.dart';
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
  Voucher? selectedVoucher;

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
    int discount = selectedVoucher?.giaTri ?? 0;
    int subtotal = calculateTotal() - discount;
    if (subtotal < 0) subtotal = 0;
    int totalAmount = (subtotal + subtotal * 0.1).toInt();

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
                      children: [
                        Text("Phiếu giảm giá"),
                        Text(
                          selectedVoucher != null
                              ? "- ${formatCurrency(selectedVoucher!.giaTri)}"
                              : "- 0 VNĐ",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã bao gồm thuế"),
                        Text(formatCurrency((subtotal * 0.1).toInt())),
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
                          formatCurrency(totalAmount),
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
            selectedVoucher == null
                ? GestureDetector(
                  onTap: () async {
                    final voucher = await Navigator.push<Voucher>(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                VoucherScreen(totalAmount: calculateTotal()),
                      ),
                    );
                    if (voucher != null) {
                      setState(() {
                        selectedVoucher = voucher;
                      });
                    }
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
                )
                : Padding(
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final voucher = await Navigator.push<Voucher>(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => VoucherScreen(
                                        totalAmount: calculateTotal(),
                                      ),
                                ),
                              );
                              if (voucher != null) {
                                setState(() {
                                  selectedVoucher = voucher;
                                });
                              }
                            },
                            child: Icon(Icons.edit, size: 18),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.confirmation_num, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "PHIẾU GIẢM GIÁ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "NotoSerif_2",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• ", style: TextStyle(fontSize: 16)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedVoucher!.tenVoucher,
                                        style: TextStyle(
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Ngày kết thúc: ${DateFormat('dd/MM/yyyy hh:mm a').format(selectedVoucher!.ngayKetThuc)}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedVoucher = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text("Xóa"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
            if (cartList.length > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PaymentScreen(
                        cartList: cartList,
                        selectedVoucher: selectedVoucher,
                        totalAmount: totalAmount,
                        total: calculateTotal(),
                        discount: discount,
                        tax: (subtotal * 0.1).toInt(),
                        quantityProduct: calculateQuantity(),
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Vui lòng mua ít nhất 1 sản phẩm trong cửa hàng!",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
