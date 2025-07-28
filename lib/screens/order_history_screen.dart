import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/bottom_navigation.dart';
import 'package:the4m_app/screens/order_detail.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedPage = "OrderHistory";
  int selectedIndex = 4;
  String selectedStatus = 'Đã Hủy';

  final List<String> statuses = ['Đang Giao', 'Đã Giao', 'Đã Hủy'];

  final List<Map<String, dynamic>> mockOrders = [
    {
      'orderNumber': '#7',
      'orderId': 'IK287399312',
      'date': '01/06/2025',
      'quantity': 3,
      'total': '1.060.000 vnd',
      'status': 'Đã Hủy',
    },
    {
      'orderNumber': '#8',
      'orderId': 'IK287369588',
      'date': '08/06/2025',
      'quantity': 1,
      'total': '250.000 vnd',
      'status': 'Đã Hủy',
    },
    {
      'orderNumber': '#9',
      'orderId': 'IK287311524',
      'date': '12/06/2025',
      'quantity': 2,
      'total': '370.000 vnd',
      'status': 'Đã Hủy',
    },
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
            _buildOrderList(),
            const SizedBox(height: 20),
            const Footer(),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            statuses.map((status) {
              final bool isSelected = selectedStatus == status;
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
                    color: isSelected ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
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

  Widget _buildOrderList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: mockOrders.map((order) => _OrderCard(order: order)).toList(),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF8F8F8),
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
                  "Order ${order['orderNumber']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(order['date'], style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text("Mã đơn hàng: ${order['orderId']}"),
            Text("Số lượng: ${order['quantity']}"),
            Text.rich(
              TextSpan(
                text: "Tổng tiền: ",
                children: [
                  TextSpan(
                    text: order['total'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['status'],
                  style: TextStyle(
                    color:
                        order['status'] == 'Đã Hủy' ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Show detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                OrderDetailScreen(orderId: order['orderId']),
                      ),
                    );
                  },
                  child: const Text("Chi Tiết"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
