import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const AdminOrderDetailScreen({Key? key, required this.orderId})
    : super(key: key);

  Future<DocumentSnapshot> fetchOrderData() async {
    return await FirebaseFirestore.instance
        .collection('DonHang')
        .doc(orderId)
        .get();
  }

  void updateOrderStatus(String status, BuildContext context) async {
    await FirebaseFirestore.instance.collection('DonHang').doc(orderId).update({
      'trangThai': status,
    });
    Navigator.pop(context); // Quay lại sau khi xác nhận
  }

  void showConfirmationDialog(BuildContext context, String status) {
    String message =
        status == 'Đã giao'
            ? 'Xác nhận đơn hàng đã được giao?'
            : 'Bạn có chắc chắn muốn chấp nhận yêu cầu huỷ đơn hàng?';

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Xác nhận'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  updateOrderStatus(status, context);
                },
                child: Text('Đồng ý'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết đơn hàng')),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchOrderData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Không tìm thấy đơn hàng'));
          }

          final data = snapshot.data!;
          final trangThai = data['trangThai'];
          final lyDoHuy =
              data.data().toString().contains('lyDoHuy') ? data['lyDoHuy'] : '';
          final ngayDat = (data['ngayDat'] as Timestamp).toDate();
          final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(ngayDat);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã đơn hàng: ${data['maDH']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('Trạng thái: $trangThai', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(
                  'Ngày đặt: $formattedDate',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                if (lyDoHuy.isNotEmpty && trangThai == 'Đã huỷ')
                  Text(
                    'Lý do huỷ: $lyDoHuy',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                Spacer(),
                if (trangThai == 'Đang giao') ...[
                  ElevatedButton(
                    onPressed: () => showConfirmationDialog(context, 'Đã giao'),
                    child: Text('Xác nhận đã giao'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
