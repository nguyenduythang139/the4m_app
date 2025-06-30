import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/widgets/voucher_item.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ÁP DỤNG PHIẾU GIẢM GIÁ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "NotoSerif_2",
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "PHIẾU GIẢM GIÁ CÓ SẴN",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "NotoSerif_2",
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "(4)",
                        style: TextStyle(
                          color: Colors.orange,
                          fontFamily: "NotoSerif_2",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 330,
                        child: Text(
                          "Chọn một phiếu giảm giá từ danh sách dưới đây và áp dụng cho đơn hàng của bạn",
                          style: TextStyle(fontFamily: "NotoSerif_2"),
                        ),
                      ),
                      Icon(Icons.info_rounded, color: Colors.orange),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(child: Column(children: [VoucherItem()])),
            ],
          ),
        ),
      ),
    );
  }
}
