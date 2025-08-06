import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/screens/order_detail_screen.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/widgets/devider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedIndex = 4;
  String selectedPage = "Thông báo";

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      listenToOrderChanges(currentUser.uid);
    }
  }

  void listenToOrderChanges(String maKH) {
    FirebaseFirestore.instance
        .collection('DonHang')
        .where('maKH', isEqualTo: maKH)
        .snapshots()
        .listen((snapshot) async {
          for (var change in snapshot.docChanges) {
            final data = change.doc.data();
            final trangThai = data?['trangThai'];
            final maDH = data?['maDH'];
            final ngayDat = data?['ngayDat'];

            if (trangThai == null || maDH == null) continue;

            String noiDung = '';
            if (trangThai == 'Đang giao') {
              noiDung = 'Bạn đã đặt đơn hàng thành công.';
            } else if (trangThai == 'Đã giao') {
              noiDung = 'Đơn hàng đã được giao thành công.';
            } else if (trangThai == 'Đã huỷ') {
              noiDung = 'Đơn hàng của bạn đã bị huỷ.';
            }

            if (noiDung.isNotEmpty) {
              final thongBaoSnapshot =
                  await FirebaseFirestore.instance
                      .collection('TaiKhoan')
                      .doc(maKH)
                      .collection('ThongBao')
                      .where('maDH', isEqualTo: maDH)
                      .where('trangThai', isEqualTo: trangThai)
                      .get();

              if (thongBaoSnapshot.docs.isEmpty) {
                await FirebaseFirestore.instance
                    .collection('TaiKhoan')
                    .doc(maKH)
                    .collection('ThongBao')
                    .add({
                      'noiDung': noiDung,
                      'maDH': maDH,
                      'ngayDat': ngayDat ?? Timestamp.now(),
                      'trangThai': trangThai,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
              }
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("Vui lòng đăng nhập.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: selectedPage,
        onSelect: (newPage) {
          setState(() => selectedPage = newPage);
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "THÔNG BÁO",
                      style: TextStyle(fontSize: 18, fontFamily: "TenorSans"),
                    ),
                    Devider(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('TaiKhoan')
                        .doc(currentUser.uid)
                        .collection('ThongBao')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 60,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2E5DF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: Colors.orange,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Hiện chưa có thông báo nào!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "NotoSerif_2",
                                color: Color(0xff333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final notifications = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final data =
                          notifications[index].data() as Map<String, dynamic>;
                      final noiDung = data['noiDung'] ?? 'Không có nội dung';
                      final maDH = data['maDH'] ?? '';
                      final ngayDat = (data['ngayDat'] as Timestamp?)?.toDate();
                      final dateStr =
                          ngayDat != null
                              ? DateFormat('dd/MM/yyyy').format(ngayDat)
                              : "";

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(orderId: maDH),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2E5DF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.notifications_active,
                                color: Colors.orange,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      noiDung,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "NotoSerif_2",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (maDH.isNotEmpty)
                                      Text(
                                        "Mã đơn hàng: $maDH",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    if (dateStr.isNotEmpty)
                                      Text(
                                        "Ngày đặt: $dateStr",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
