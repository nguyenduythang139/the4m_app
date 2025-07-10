import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/drawer.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/bottom_navigation.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  String selectedPage = "Liên lạc";

  int _currentIndex = 1; // Ví dụ Contact là tab index 1 (Tìm kiếm)

  static const iconColor = Color(0xFFDD8560);

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // TODO: Thêm logic điều hướng màn hình tùy index ở đây nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: selectedPage,
        onSelect: (String newPage) {
          setState(() {
            selectedPage = newPage;
          });
          Navigator.pop(context);
        },
      ),
      appBar: const Header(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'LIÊN HỆ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Tenor Sans',
                  fontWeight: FontWeight.w400,
                  height: 2.22,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cần hỗ trợ gấp? Liên hệ với chúng tôi qua chat 24/7!',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Tenor Sans',
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.support_agent, color: iconColor, size: 50),
                SizedBox(width: 30),
                Icon(Icons.phone_in_talk, color: iconColor, size: 50),
                SizedBox(width: 30),
                Icon(Icons.chat_bubble_outline, color: iconColor, size: 50),
              ],
            ),

            const SizedBox(height: 40),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                decoration: BoxDecoration(color: Colors.black),
                child: const Text(
                  'PHẢN HỒI',
                  style: TextStyle(
                    color: Color(0xFFFCFCFC),
                    fontSize: 16,
                    fontFamily: 'Tenor Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Bạn có thể nhắn tin cho chúng tôi qua số 000-000-000 – hoặc nhấn vào liên kết "Nhắn tin" bên dưới nếu đang sử dụng thiết bị di động. Vui lòng để hệ thống nhận diện lời chào đầu tiên (chỉ cần “Hi” là đủ!) trước khi gửi câu hỏi hoặc thông tin đơn hàng của bạn. Bạn không bắt buộc phải đồng ý bất kỳ điều gì để mua hàng. Có thể áp dụng cước phí tin nhắn và dữ liệu. Dịch vụ nhắn tin có thể không khả dụng với một số nhà mạng.',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Tenor Sans',
                fontWeight: FontWeight.w400,
                height: 1.44,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 8,
                ),
                decoration: BoxDecoration(color: Colors.black),
                child: const Text(
                  'NHẮN TIN',
                  style: TextStyle(
                    color: Color(0xFFFCFCFC),
                    fontSize: 16,
                    fontFamily: 'Tenor Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Để gửi tin nhắn riêng cho chúng tôi, hãy nhấn thích @4m Fashion trên Facebook hoặc theo dõi chúng tôi trên Twitter. Chúng tôi sẽ phản hồi bạn nhanh nhất có thể. Vui lòng cung cấp tên, mã đơn hàng và địa chỉ email để được hỗ trợ nhanh hơn!',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16,
                fontFamily: 'Tenor Sans',
                fontWeight: FontWeight.w400,
                height: 1.44,
              ),
            ),

            const SizedBox(height: 40),

            const Footer(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
