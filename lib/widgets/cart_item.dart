import 'package:flutter/material.dart';
import 'package:the4m_app/models/cart_model.dart';
import 'package:intl/intl.dart';

class CartItem extends StatelessWidget {
  final Cart cart;

  const CartItem({super.key, required this.cart});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
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
                      child: Image.asset(cart.productImage, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 210,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cart.productName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Màu sắc: " + cart.productColor,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Kích cỡ: Size " + cart.productSize,
                              style: TextStyle(
                                color: Color(0xff333333),
                                fontFamily: "NotoSerif_2",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              formatCurrency(cart.productPrice).toString(),
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
                                    onPressed: () {},
                                    icon: Icon(Icons.remove, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(cart.productQuantity.toString()),
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
                                    onPressed: () {},
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
                        Container(
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
                      "350.000 VNĐ",
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
