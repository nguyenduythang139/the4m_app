import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? orderData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('DonHang')
            .doc(widget.orderId)
            .get();

    if (doc.exists) {
      setState(() {
        orderData = doc.data();
        loading = false;
      });
    } else {
      setState(() {
        orderData = null;
        loading = false;
      });
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (orderData == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy đơn hàng")),
      );
    }

    final info = orderData!['thongTinGiaoHang'] ?? [];
    List<dynamic> products = orderData!['sanPham'] ?? [];

    String status = orderData!['trangThai'] ?? '';
    Color statusColor;

    if (status == "Đang giao") {
      statusColor = Colors.orange;
    } else if (status == "Đã giao") {
      statusColor = Colors.green;
    } else if (status == "Đã hủy") {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Chi tiết đơn hàng ${orderData!['maDH'] ?? ''}"),
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
            _buildInfoRow1("Mã đơn hàng", orderData!['maDH'] ?? ''),
            _buildInfoRow1(
              "Ngày đặt hàng",
              (orderData!['ngayDat'] as Timestamp)
                  .toDate()
                  .toString()
                  .substring(0, 10),
            ),
            _buildInfoRow1("Tên người nhận", info['hoTen'] ?? ''),
            _buildInfoRow1("Số điện thoại", info['soDienThoai'] ?? ''),
            _buildInfoRow1(
              "Địa chỉ giao hàng",
              (info['diaChi'] +
                      ", " +
                      info['phuong'] +
                      ", " +
                      info['thanhPho']) ??
                  '',
            ),
            _buildInfoRow1(
              "Phương thức thanh toán",
              orderData!['phuongThucThanhToan'] ?? '',
            ),
            _buildInfoRow1(
              "Phương thức giao hàng",
              orderData!['phuongThucGiaoHang'] ?? '',
            ),
            Divider(height: 32),
            _buildInfoRow2(
              "Tổng tiền sản phẩm",
              "${formatCurrency(orderData!['tongTien'])}",
            ),
            _buildInfoRow2(
              "Giảm giá",
              orderData!['giamGia'] != null && orderData!['giamGia'] > 0
                  ? "- ${formatCurrency(orderData!['giamGia'])}"
                  : "- 0 VNĐ",
            ),
            _buildInfoRow2("Thuế", "${formatCurrency(orderData!['thue'])}"),
            _buildInfoRow2(
              "Phí vận chuyển",
              "${formatCurrency(orderData!['phiGiaoHang'])}",
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng cộng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${formatCurrency(orderData!['thanhTien'])}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: statusColor),
                ),
                child: Text(
                  orderData!['trangThai'] ?? '',
                  style: TextStyle(color: statusColor),
                ),
              ),
            ),
            Divider(height: 32),
            Text(
              "Sản phẩm đã đặt",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...products.map((p) => _buildProductItem(p)).toList(),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (orderData!['trangThai'] == "Đã giao") {
                    // Hiển thị thông báo không thể huỷ
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Không thể huỷ đơn"),
                            content: const Text(
                              "Đơn hàng của bạn đã được giao và không thể huỷ.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Đóng"),
                              ),
                            ],
                          ),
                    );
                  } else if (orderData!['trangThai'] == "Đang giao") {
                    // Hiển thị hộp thoại nhập lý do huỷ
                    showDialog(
                      context: context,
                      builder: (_) {
                        final TextEditingController reasonController =
                            TextEditingController();

                        return AlertDialog(
                          title: const Text("Huỷ đơn hàng"),
                          content: TextField(
                            controller: reasonController,
                            decoration: const InputDecoration(
                              hintText: "Nhập lý do huỷ đơn hàng",
                            ),
                            maxLines: 3,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Thoát"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final reason = reasonController.text.trim();
                                if (reason.isEmpty) return;

                                await FirebaseFirestore.instance
                                    .collection("DonHang")
                                    .doc(widget.orderId)
                                    .update({
                                      "yeuCauHuy": true,
                                      "lyDoHuy": reason,
                                      "thoiGianYeuCauHuy":
                                          FieldValue.serverTimestamp(),
                                    });

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Yêu cầu huỷ đơn đã được gửi.",
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );

                                fetchOrderDetail(); // Reload đơn hàng
                              },
                              child: const Text("Gửi yêu cầu"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  orderData!['trangThai'] == "Đã giao"
                      ? "Đổi trả sản phẩm"
                      : "Huỷ đơn hàng",
                  style: const TextStyle(
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
            width: 170,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(": $value")),
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

  Widget _buildProductItem(Map<String, dynamic> product) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool daDanhGia = product['daDanhGia'] == true;
    bool daGiao = orderData!['trangThai'] == "Đã giao";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product['hinhAnh'] ??
                      "https://via.placeholder.com/80x100.png?text=No+Image",
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product['tenSP'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Size: ${product['kichThuoc'] ?? 'N/A'} - Màu: ${product['mauSac'] ?? ''}",
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${formatCurrency(product['gia'])}",
                          style: const TextStyle(color: Colors.orange),
                        ),
                        Text("x${product['soLuong']}"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (daGiao)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: daDanhGia ? null : () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue[700],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      daDanhGia ? "Đã đánh giá" : "Đánh giá sản phẩm",
                      style: TextStyle(
                        color: daDanhGia ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
