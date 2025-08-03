import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';

class CompleteOrderScreen extends StatefulWidget {
  final String orderId;
  final int? totalAmount;
  final String selectedPaymentMethod;

  const CompleteOrderScreen({
    super.key,
    required this.orderId,
    this.totalAmount,
    required this.selectedPaymentMethod,
  });

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
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
                          "ĐẶT HÀNG THÀNH CÔNG",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "TenorSans",
                          ),
                        ),
                        Devider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 25),
                    SizedBox(width: 5),
                    ...List.generate(5, (index) => dotLine()),
                    SizedBox(width: 5),
                    Icon(Icons.credit_card, color: Colors.orange, size: 25),
                    SizedBox(width: 5),
                    ...List.generate(5, (index) => dotLine()),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.orange,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
            // Thông tin đơn hàng
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Icon thành công
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                    SizedBox(height: 20),

                    // Thông báo thành công
                    Text(
                      "Thanh toán thành công!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Cảm ơn bạn đã mua hàng tại 4M",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),

                    // Thông tin đơn hàng
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THÔNG TIN ĐƠN HÀNG",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mã đơn hàng:"),
                              Text(
                                widget.orderId,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ngày đặt:"),
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(DateTime.now()),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          if (widget.totalAmount != null) ...[
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tổng tiền:"),
                                Text(
                                  formatCurrency(widget.totalAmount!),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Phương thức:"),
                              Text(
                                widget.selectedPaymentMethod,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Thông báo tiếp theo
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                "Thông tin tiếp theo",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "• Đơn hàng sẽ được xử lý trong 24h\n"
                            "• Chúng tôi sẽ giao hành sớm nhất có thể! \n"
                            "• Theo dõi đơn hàng trong mục 'Đơn hàng của tôi'",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          },
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            "TIẾP TỤC MUA SẮM",
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

Widget dotLine() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Color(0xffC8C7CC),
        shape: BoxShape.circle,
      ),
    ),
  );
}
