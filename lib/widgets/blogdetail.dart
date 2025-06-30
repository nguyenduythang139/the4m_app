import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/imagesblog.dart';

class BlogDetail extends StatelessWidget {
  final String imageUrl;
  final String title;
  final List<String> hashtags;
  final String date;
  final String content1; // đoạn 1
  final String content2; // đoạn 2
  final String midImageUrl;

  const BlogDetail({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.hashtags,
    required this.date,
    required this.content1,
    required this.content2,
    required this.midImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner ảnh đầu bài
            ImageWidget(
              imageUrl: imageUrl,
              isAsset: true,
              height: 200,
              borderRadius: 4,
            ),
            const SizedBox(height: 20),

            // Tiêu đề
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tenor Sans',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),

            // Nội dung phần 1
            Text(
              content1,
              style: const TextStyle(
                fontFamily: 'Tenor Sans',
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 24),

            // Ảnh minh họa giữa bài
            ImageWidget(
              imageUrl: midImageUrl,
              isAsset: false,
              height: 500,
              borderRadius: 12,
            ),

            const SizedBox(height: 24),

            // Nội dung phần 2
            Text(
              content2,
              style: const TextStyle(
                fontFamily: 'Tenor Sans',
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 32),

            // Hashtags + Ngày
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        hashtags.map((tag) {
                          return Chip(
                            label: Text(
                              tag,
                              style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 12,
                                fontFamily: 'Tenor Sans',
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Color(0xFFF5F5F5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontFamily: 'Tenor Sans',
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Footer(),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black.withOpacity(0.8),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Mua sắm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
      ),
    );
  }
}
