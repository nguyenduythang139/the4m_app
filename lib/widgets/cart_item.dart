import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:intl/intl.dart';

class CartItem extends StatefulWidget {
  final Cart cart;
  final VoidCallback onRemove;
  final void Function(int) onQuantityChange;

  const CartItem({
    super.key,
    required this.cart,
    required this.onRemove,
    required this.onQuantityChange,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int soLuong;

  @override
  void initState() {
    super.initState();
    soLuong = widget.cart.soLuong;
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  Future<void> removeFromCart(BuildContext context) async {
    try {
      final cartRef = FirebaseFirestore.instance
          .collection('TaiKhoan')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('GioHang')
          .doc(widget.cart.id);
      await cartRef.delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Đã xóa sản phẩm khỏi giỏ hàng")));

      widget.onRemove();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Xóa thất bại: $e")));
    }
  }

  Future<void> updateQuantity(BuildContext context, int newQuantity) async {
    if (newQuantity <= 0) {
      removeFromCart(context);
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('TaiKhoan')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('GioHang')
          .doc(widget.cart.id);

      await cartRef.update({'soLuong': newQuantity});

      setState(() {
        soLuong = newQuantity;
      });

      widget.onQuantityChange(newQuantity);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Cập nhật số lượng thất bại: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        color: Color(0xffEEEDED),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 95,
                      child: Image.asset(
                        widget.cart.hinhAnh,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 210,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cart.tenSP,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Màu sắc: " + widget.cart.mauSac,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Kích cỡ: Size " + widget.cart.kichThuoc,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              formatCurrency(widget.cart.gia).toString(),
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "NotoSerif_2",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffC4C4C4),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed:
                                        () => updateQuantity(
                                          context,
                                          soLuong - 1,
                                        ),
                                    icon: Icon(Icons.remove, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(soLuong.toString()),
                                SizedBox(width: 10),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffC4C4C4),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed:
                                        () => updateQuantity(
                                          context,
                                          soLuong + 1,
                                        ),
                                    icon: Icon(Icons.add, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => removeFromCart(context),
                          child: Container(
                            width: 46,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                "Xóa",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "TenorSans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Tổng: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: "NotoSerif_2",
                      ),
                    ),
                    Text(
                      formatCurrency(
                        widget.cart.gia * widget.cart.soLuong,
                      ).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontFamily: "NotoSerif_2",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
