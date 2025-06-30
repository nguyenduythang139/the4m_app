import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/header.dart';

class OurStoryScreen extends StatefulWidget {
  const OurStoryScreen({super.key});

  @override
  State<OurStoryScreen> createState() => _OurStoryScreenState();
}

class _OurStoryScreenState extends State<OurStoryScreen> {
  final TextEditingController _emailController = TextEditingController();
  int selectedIndex = 0;

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đúng địa chỉ email.')),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cảm ơn bạn đã đăng ký!')));
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            const Text(
              'THÔNG TIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Tenor Sans',
                letterSpacing: 4,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              '4&M (For Men) là cửa hàng thời trang nam hiện đại, chuyên cung cấp những mẫu quần áo mang phong cách trẻ trung, năng động và lịch lãm. Với phương châm “Đẹp – Đơn giản – Đậm chất nam tính”, 4&M luôn cập nhật xu hướng mới để mang đến cho khách hàng những trải nghiệm thời trang độc đáo, phù hợp cho cả đi làm lẫn đi chơi.\n\nĐội ngũ tư vấn nhiệt tình, không gian mua sắm hiện đại, 4&M cam kết mang lại sự hài lòng cho từng khách hàng.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Tenor Sans',
                color: Color(0xFF333333),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://forgecraftmensjewelry.com/cdn/shop/articles/minimalist-mens-fashion-beige-shirt-and-trousers.jpg?v=1737391858&width=1100',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('Không thể tải ảnh')),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              'ĐĂNG KÝ',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Tenor Sans',
                letterSpacing: 4,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Nhận quyền truy cập sớm vào các sản phẩm mới, chương trình giảm giá, sự kiện và nhiều ưu đãi!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Tenor Sans',
                color: Color(0xFF888888),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Địa chỉ Email',
                hintStyle: const TextStyle(
                  fontFamily: 'Tenor Sans',
                  color: Color(0xFF979797),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD3D3D3)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD8560),
                ),
                child: const Text(
                  'GỬI',
                  style: TextStyle(
                    fontFamily: 'Tenor Sans',
                    fontSize: 14,
                    letterSpacing: 0.14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              '© 2025 4&M Fashion',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'Tenor Sans',
              ),
            ),
            const SizedBox(height: 20),
            const Footer(),
          ],
        ),
      ),

      // ✅ Thêm bottomNavigationBar
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
