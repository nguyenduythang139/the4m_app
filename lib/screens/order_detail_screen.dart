import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Chi tiết đơn hàng #9"),
        centerTitle: true,
        actions: const [Icon(Icons.refresh), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chi tiết đơn hàng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow1("Mã đơn hàng", "IK287399312"),
            _buildInfoRow1("Ngày đặt hàng", "12/06/2025"),
            _buildInfoRow1("Tên người nhận", "Nguyen Van A"),
            _buildInfoRow1("Số điện thoại", "0900000003"),
            _buildInfoRow1(
              "Địa chỉ giao hàng",
              "1 Nguyễn Huệ, Phường Sài Gòn, TP Hồ Chí Minh",
            ),
            _buildInfoRow1(
              "Phương thức thanh toán",
              "Thanh toán tiền mặt khi nhận hàng",
            ),
            const Divider(height: 32),
            _buildInfoRow2("Tổng tiền sản phẩm", "1,078,000 đ"),
            _buildInfoRow2("Phí vận chuyển", "20,000 đ"),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng cộng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "1,078,000 đ",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.orange),
                ),
                child: const Text(
                  "Đang giao",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            const Divider(height: 32),
            const Text(
              "Sản phẩm đã đặt",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildProductItem(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Huỷ đơn hàng",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow1(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(": " + value)),
        ],
      ),
    );
  }

  Widget _buildInfoRow2(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label :",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: Text(value)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://i.pinimg.com/736x/52/86/73/52867315bfd3e36e7f7f59b1601091a8.jpg",
              width: 80,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Áo thun dry cổ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("2 sản phẩm"),
                  ],
                ),
                SizedBox(height: 4),
                Text("Size: XL"),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("300,000 đ", style: TextStyle(color: Colors.red)),
                    Text("x1"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
