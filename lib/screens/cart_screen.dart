import 'package:flutter/material.dart';
import 'package:the4m_app/screens/voucher_screen.dart';
import 'package:the4m_app/widgets/cart_item.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/models/cart_model.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> sampleCartList = [
    Cart(
      productImage: "lib/assets/images/product_1.png",
      productName: "Áo thun dry cổ tròn nhiều màu",
      productColor: "Đen",
      productSize: "M",
      productPrice: 350000,
      productQuantity: 1,
    ),
    Cart(
      productImage: "lib/assets/images/product_2.png",
      productName: "Áo thun dry cổ tròn nhiều màu",
      productColor: "Trắng",
      productSize: "L",
      productPrice: 280000,
      productQuantity: 2,
    ),
  ];

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sampleCartList.length,
                itemBuilder: (context, index) {
                  return CartItem(cart: sampleCartList[index]);
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
                    Text("TỔNG ĐƠN HÀNG | ${sampleCartList.length} SẢN PHẨM"),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tổng cộng"),
                        Text(
                          "${formatCurrency(calculateTotal())}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Phiếu giảm giá"), Text("0 VNĐ")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã bao gồm thuế"),
                        Text(
                          "${formatCurrency((calculateTotal() * 0.1).toInt())}",
                        ),
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
                          "${formatCurrency((calculateTotal() * 1.1).toInt())}",
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
                          Text(
                            "PHIẾU GIẢM GIÁ",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: "NotoSerif_2",
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ),
            // Nut tiep tuc mua
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(),
                ),
                onPressed: () {},
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  "THANH TOÁN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ham tinh tong
  int calculateTotal() {
    int total = 0;
    for (var item in sampleCartList) {
      total += item.productPrice * item.productQuantity;
    }
    return total;
  }
}
