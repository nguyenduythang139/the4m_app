import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_order_detail_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _xacNhanDaGiao(String maDH) async {
    await FirebaseFirestore.instance.collection('DonHang').doc(maDH).update({
      'trangThai': 'Đã giao',
    });
  }

  void _chapNhanHuy(String maDH) async {
    await FirebaseFirestore.instance.collection('DonHang').doc(maDH).update({
      'trangThai': 'Đã huỷ',
    });
  }

  Widget _buildDonHangItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final maDH = data['maDH'] ?? '';
    final trangThai = data['trangThai'] ?? '';
    final yeuCauHuy = data['yeuCauHuy'] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Mã đơn hàng: $maDH'),
        subtitle: Text('Trạng thái: $trangThai'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminOrderDetailScreen(orderId: maDH),
            ),
          );
        },
        trailing:
            trangThai == 'Đang giao'
                ? ElevatedButton(
                  onPressed: () => _xacNhanDaGiao(maDH),
                  child: const Text('Xác nhận đã giao'),
                )
                : const SizedBox(),
      ),
    );
  }

  Widget _buildYeuCauHuyItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final maDH = data['maDH'] ?? '';
    final trangThai = data['trangThai'] ?? '';
    final lyDoHuy = data['lyDoHuy'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Mã đơn hàng: $maDH'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trạng thái: $trangThai'),
            Text('Lý do huỷ: $lyDoHuy'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminOrderDetailScreen(orderId: maDH),
            ),
          );
        },
        trailing:
            trangThai == 'Đã huỷ'
                ? const Chip(label: Text('Đã huỷ'))
                : ElevatedButton(
                  onPressed: () => _chapNhanHuy(maDH),
                  child: const Text('Chấp nhận huỷ'),
                ),
      ),
    );
  }

  Widget _buildTab(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('DonHang')
              .where('trangThai', isEqualTo: status)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text('Không có đơn hàng'));
        return ListView(children: docs.map(_buildDonHangItem).toList());
      },
    );
  }

  Widget _buildYeuCauHuyTab() {
    final donHangRef = FirebaseFirestore.instance.collection('DonHang');

    final yeuCauHuyQuery = donHangRef.where('yeuCauHuy', isEqualTo: true).get();
    final daHuyQuery = donHangRef.where('trangThai', isEqualTo: 'Đã huỷ').get();

    return FutureBuilder<List<QuerySnapshot>>(
      future: Future.wait([yeuCauHuyQuery, daHuyQuery]),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final yeuCauHuyDocs = snapshot.data![0].docs;
        final daHuyDocs = snapshot.data![1].docs;

        // Gộp và loại bỏ trùng nếu có
        final allDocsMap = {
          for (var doc in [...yeuCauHuyDocs, ...daHuyDocs]) doc.id: doc,
        };
        final allDocs = allDocsMap.values.toList();

        if (allDocs.isEmpty) {
          return const Center(child: Text('Không có đơn hàng yêu cầu huỷ'));
        }

        return ListView(children: allDocs.map(_buildYeuCauHuyItem).toList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Quản lý đơn hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang giao'),
            Tab(text: 'Đã giao'),
            Tab(text: 'Yêu cầu huỷ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab('Đang giao'),
          _buildTab('Đã giao'),
          _buildYeuCauHuyTab(),
        ],
      ),
    );
  }
}
