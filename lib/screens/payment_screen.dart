import 'package:flutter/material.dart';
import 'package:the4m_app/models/delivery_method_model.dart';
import 'package:the4m_app/models/payment_method_model.dart';
import 'package:the4m_app/screens/add_address_screen.dart';
import 'package:the4m_app/screens/cart_screen.dart';
import 'package:the4m_app/screens/complete_order_screen.dart';
import 'package:the4m_app/screens/voucher_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<DeliveryMethodOption> deliveryMethods = [
    DeliveryMethodOption(name: 'Chuyển phát nhanh', price: '40.000 VNĐ'),
    DeliveryMethodOption(name: 'Giao tiêu chuẩn', price: '20.000 VNĐ'),
    DeliveryMethodOption(name: 'Giao tiết kiệm', price: 'MIỄN PHÍ'),
  ];

  DeliveryMethodOption? selectedDeliveryMethod;

  final List<PaymentMethodOption> paymentMethods = [
    PaymentMethodOption(name: 'Thanh toán tiền mặt'),
    PaymentMethodOption(name: 'Thanh toán bằng vnpay'),
  ];

  PaymentMethodOption? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    selectedDeliveryMethod = deliveryMethods.first;
    selectedPaymentMethod = paymentMethods.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "THANH TOÁN",
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
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            ...List.generate(5, (index) => dotLine()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.credit_card,
                              color: Colors.orange,
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            ...List.generate(5, (index) => dotLine()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xffC8C7CC),
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Thong tin don hang
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ĐỊA CHỈ GIAO HÀNG",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAddressScreen(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Nguyễn Duy Thắng",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "312/8/9, Quang Trung\nPhường 10, Gò Vấp, TP Hồ Chí Minh\n0336971705",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "NotoSerif_2",
                                          color: Color(0xff555555),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                          // Chon phuong thuc van chuyen
                          SizedBox(height: 20),
                          Text(
                            "PHƯƠNG THỨC VẬN CHUYỂN",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<DeliveryMethodOption>(
                            dropdownColor: Colors.white,
                            value: selectedDeliveryMethod,
                            items:
                                deliveryMethods.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            method.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "NotoSerif_2",
                                              color: Color(0xff555555),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          method.price,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "NotoSerif_2",
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDeliveryMethod = value!;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return deliveryMethods.map((method) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      method.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "NotoSerif_2",
                                        color: Color(0xff555555),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "-",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      method.price,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "NotoSerif_2",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                          SizedBox(height: 20),
                          // Chon phuong thuc thanh toan
                          Text(
                            "PHƯƠNG THỨC THANH TOÁN",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<PaymentMethodOption>(
                            dropdownColor: Colors.white,
                            value: selectedPaymentMethod,
                            items:
                                paymentMethods.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            method.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "NotoSerif_2",
                                              color: Color(0xff555555),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return paymentMethods.map((method) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      method.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "NotoSerif_2",
                                        color: Color(0xff555555),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                          // Tong tien
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("TỔNG ĐƠN HÀNG | 4 SẢN PHẨM"),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tổng cộng"),
                                      Text(
                                        "1.001.000 VNĐ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Phiếu giảm giá"),
                                      Text("- 100.000 VNĐ"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Đã bao gồm thuế"),
                                      Text("91.000 VNĐ"),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "THÀNH TIỀN:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "941.000 VNĐ",
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
                          // Thong tin phieu giam gia
                          Container(
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VoucherScreen(),
                                        ),
                                      );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "• ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Mã Giảm Giá Chào Mừng - 06/2025",
                                                style: TextStyle(
                                                  fontFamily: "NotoSerif_2",
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Ngày kết thúc: 30/06/2025 12:00 PM ICT",
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
                                          onTap: () {},
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                          SizedBox(height: 20),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompleteOrderScreen()),
            );
          },
          icon: Icon(Icons.credit_score_rounded, color: Colors.white),
          label: Text(
            "HOÀN TẤT ĐẶT HÀNG",
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
