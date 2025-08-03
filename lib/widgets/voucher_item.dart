import 'package:flutter/material.dart';
import 'package:the4m_app/models/voucher.dart';

class VoucherItem extends StatelessWidget {
  final Voucher voucher;
  final VoidCallback onSelect;
  const VoucherItem({super.key, required this.voucher, required this.onSelect});

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
                          voucher.tenVoucher,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Ngày bắt đầu:  ${voucher.ngayBatDau}",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Ngày kết thúc: ${voucher.ngayKetThuc}",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "NotoSerif_2",
                          ),
                        ),
                        Text(
                          "Giá trị voucher: ${voucher.giaTri} VNĐ",
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
              GestureDetector(
                onTap: onSelect,
                child: Container(
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
