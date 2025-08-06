import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/drawer.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/bottom_navigation.dart';
import 'package:the4m_app/screens/order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedPage = "OrderHistory";
  int selectedIndex = 4;
  String selectedStatus = 'Đang giao';

  final List<String> statuses = ['Đang giao', 'Đã giao', 'Đã hủy'];

  Future<String?> _getMaKH() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final khSnapshot =
        await FirebaseFirestore.instance
            .collection('KhachHang')
            .where('maTK', isEqualTo: currentUser.uid)
            .limit(1)
            .get();

    if (khSnapshot.docs.isEmpty) return null;
    return khSnapshot.docs.first['maKH'] as String;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getOrders(String maKH) {
    return FirebaseFirestore.instance
        .collection('DonHang')
        .where('maKH', isEqualTo: maKH)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: selectedPage,
        onSelect: (newPage) {
          setState(() => selectedPage = newPage);
          Navigator.pop(context);
        },
      ),
      appBar: const Header(),
      body: FutureBuilder<String?>(
        future: _getMaKH(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Không tìm thấy khách hàng"));
          }
          final maKH = snapshot.data!;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _getOrders(maKH),
            builder: (context, orderSnapshot) {
              if (orderSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!orderSnapshot.hasData || orderSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Không có đơn hàng nào"));
              }

              final filteredOrders =
                  orderSnapshot.data!.docs.where((doc) {
                    final trangThai =
                        doc['trangThai']?.toString().toLowerCase();
                    return trangThai == selectedStatus.toLowerCase();
                  }).toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'LỊCH SỬ ĐẶT HÀNG',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Tenor Sans',
                        fontWeight: FontWeight.w400,
                        height: 2.22,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildStatusTabs(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children:
                            filteredOrders
                                .map((doc) => _OrderCard(order: doc.data()))
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Footer(),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildStatusTabs() {
    Color getStatusColor(String status) {
      switch (status) {
        case 'Đang giao':
          return Colors.orange;
        case 'Đã giao':
          return Colors.green;
        case 'Đã hủy':
          return Colors.red;
        default:
          return Colors.black;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            statuses.map((status) {
              final bool isSelected = selectedStatus == status;
              final Color color = getStatusColor(status);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStatus = status;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontFamily: 'Tenor Sans',
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ${order['maDH'] ?? ''}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order['ngayDat'] != null
                      ? (order['ngayDat'] as Timestamp)
                          .toDate()
                          .toString()
                          .substring(0, 10)
                      : "",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Số lượng: ${order['tongSoLuong'] ?? 0} sản phẩm"),
            Text("Tổng tiền: ${formatCurrency(order['thanhTien'])}"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['trangThai'] ?? '',
                  style: TextStyle(
                    color:
                        (order['trangThai'] == 'Đã hủy')
                            ? Colors.red
                            : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OrderDetailScreen(orderId: order['maDH']),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: const Text("Chi Tiết"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
