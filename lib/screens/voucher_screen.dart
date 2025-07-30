import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 320,
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(children: [VoucherItem()]),
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
          label: Text(
            "QUAY LẠI",
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
