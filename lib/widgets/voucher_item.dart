import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/devider.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "lib/assets/images/voucher.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MÃ GIẢM GIÁ CHÀO MỪNG - 06/2025",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Ngày bắt đầu:  01/06/2025 12:00 PM ICT",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Ngày kết thúc: 30/06/2025 12:00 PM ICT",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Giá trị voucher: 100.000 VNĐ",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "CHỌN",
                  style: TextStyle(fontSize: 12, fontFamily: "NotoSerif_2"),
                ),
              ),
              SizedBox(width: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "CHI TIẾT",
                  style: TextStyle(fontSize: 12, fontFamily: "NotoSerif_2"),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(),
        ],
      ),
    );
  }
}
