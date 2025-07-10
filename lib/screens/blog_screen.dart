import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/drawer.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/blogdetail.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    String selectedPage = "Blog";

    final List<Map<String, dynamic>> blogs = [
      {
        'image': 'lib/assets/images/blog_1.png',
        'title': 'PHONG CÁCH 2025: XU HƯỚNG LỊCH LÃM',
        'midImageUrl':
            'https://i.pinimg.com/736x/52/86/73/52867315bfd3e36e7f7f59b1601091a8.jpg',
        'hashtags': ['#Fashion', '#Tips'],
        'date': '4 days ago',
        'content1':
            'Năm nay, mình tập trung vào những item vừa thanh lịch vừa dễ phối – kết hợp giữa đồ cao cấp và bình dân để tạo nên phong cách riêng. Những mẫu áo blazer, quần suông hay sơ mi tối giản chính là lựa chọn hàng đầu giúp mình luôn chỉn chu mà vẫn thời thượng. Blazer dáng suông, sơ mi tối giản, quần âu cạp cao hay những chiếc áo len mỏng gam trung tính đang là lựa chọn yêu thích của mình trong năm nay.',
        'content2':
            'Bên cạnh đó, mình cũng ưu tiên chất liệu thoải mái, đứng form để dễ dàng di chuyển mà vẫn giữ được vẻ tinh tế. Những gam màu trung tính như be, ghi, trắng hay đen giúp mình dễ dàng phối đồ theo nhiều phong cách khác nhau – từ công sở đến dạo phố. Mình luôn tin rằng, sự tối giản nhưng có điểm nhấn chính là chìa khóa để tạo nên vẻ ngoài thanh lịch và cuốn hút.',
      },
      {
        'image': 'lib/assets/images/blog_2.png',
        'title': 'PHONG CÁCH 2025: XU HƯỚNG LỊCH LÃM',
        'midImageUrl': 'https://example.com/mid-image.jpg',
        'hashtags': ['#Sale', '#Summer'],
        'date': '7 days ago',
        'content1':
            'Năm nay, mình tập trung vào những item vừa thanh lịch vừa dễ phối – kết hợp giữa đồ cao cấp và bình dân để tạo nên phong cách riêng. Những mẫu áo blazer, quần suông hay sơ mi tối giản chính là lựa chọn hàng đầu giúp mình luôn chỉn chu mà vẫn thời thượng. Blazer dáng suông, sơ mi tối giản, quần âu cạp cao hay những chiếc áo len mỏng gam trung tính đang là lựa chọn yêu thích của mình trong năm nay.',
        'content2':
            'Bên cạnh đó, mình cũng ưu tiên chất liệu thoải mái, đứng form để dễ dàng di chuyển mà vẫn giữ được vẻ tinh tế. Những gam màu trung tính như be, ghi, trắng hay đen giúp mình dễ dàng phối đồ theo nhiều phong cách khác nhau – từ công sở đến dạo phố. Mình luôn tin rằng, sự tối giản nhưng có điểm nhấn chính là chìa khóa để tạo nên vẻ ngoài thanh lịch và cuốn hút.',
      },
      {
        'image': 'lib/assets/images/blog_3.png',
        'title': 'PHONG CÁCH 2025: XU HƯỚNG LỊCH LÃM',
        'midImageUrl': 'https://example.com/mid-image.jpg',
        'hashtags': ['#Style', '#Weekend'],
        'date': '2 weeks ago',
        'content1':
            'Năm nay, mình tập trung vào những item vừa thanh lịch vừa dễ phối – kết hợp giữa đồ cao cấp và bình dân để tạo nên phong cách riêng. Những mẫu áo blazer, quần suông hay sơ mi tối giản chính là lựa chọn hàng đầu giúp mình luôn chỉn chu mà vẫn thời thượng. Blazer dáng suông, sơ mi tối giản, quần âu cạp cao hay những chiếc áo len mỏng gam trung tính đang là lựa chọn yêu thích của mình trong năm nay.',
        'content2':
            'Bên cạnh đó, mình cũng ưu tiên chất liệu thoải mái, đứng form để dễ dàng di chuyển mà vẫn giữ được vẻ tinh tế. Những gam màu trung tính như be, ghi, trắng hay đen giúp mình dễ dàng phối đồ theo nhiều phong cách khác nhau – từ công sở đến dạo phố. Mình luôn tin rằng, sự tối giản nhưng có điểm nhấn chính là chìa khóa để tạo nên vẻ ngoài thanh lịch và cuốn hút.',
      },
      {
        'image': 'lib/assets/images/blog_4.png',
        'title': 'PHONG CÁCH 2025: XU HƯỚNG LỊCH LÃM',
        'midImageUrl': 'https://example.com/mid-image.jpg',
        'hashtags': ['#Policy', '#Support'],
        'date': '3 weeks ago',
        'content1':
            'Năm nay, mình tập trung vào những item vừa thanh lịch vừa dễ phối – kết hợp giữa đồ cao cấp và bình dân để tạo nên phong cách riêng. Những mẫu áo blazer, quần suông hay sơ mi tối giản chính là lựa chọn hàng đầu giúp mình luôn chỉn chu mà vẫn thời thượng. Blazer dáng suông, sơ mi tối giản, quần âu cạp cao hay những chiếc áo len mỏng gam trung tính đang là lựa chọn yêu thích của mình trong năm nay.',
        'content2':
            'Bên cạnh đó, mình cũng ưu tiên chất liệu thoải mái, đứng form để dễ dàng di chuyển mà vẫn giữ được vẻ tinh tế. Những gam màu trung tính như be, ghi, trắng hay đen giúp mình dễ dàng phối đồ theo nhiều phong cách khác nhau – từ công sở đến dạo phố. Mình luôn tin rằng, sự tối giản nhưng có điểm nhấn chính là chìa khóa để tạo nên vẻ ngoài thanh lịch và cuốn hút.',
      },
    ];

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'BLOG',
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
              const SizedBox(height: 20),
              _buildCategoryTabs(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children:
                      blogs
                          .map((blog) => _buildBlogCard(context, blog))
                          .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDEDEDE)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 33,
                      vertical: 12,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'XEM THÊM',
                        style: TextStyle(
                          fontFamily: 'Tenor Sans',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.expand_more, size: 24, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Footer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Xử lý chuyển tab, bạn có thể thay bằng Navigator.push...
          print("Đã chọn tab $index");
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _CategoryChip(title: 'Thời Trang', isSelected: true),
          _CategoryChip(title: 'Giảm Giá'),
          _CategoryChip(title: 'Chính Sách'),
        ],
      ),
    );
  }

  Widget _buildBlogCard(BuildContext context, Map<String, dynamic> blog) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlogDetail(
                  imageUrl: blog['image'],
                  title: blog['title'],
                  hashtags: List<String>.from(blog['hashtags']),
                  date: blog['date'],
                  midImageUrl: blog['midImageUrl'],
                  content1: blog['content1'],
                  content2: blog['content2'],
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: AssetImage(blog['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 90,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF111111), Color(0x00111111)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 20,
                  child: Text(
                    blog['title'],
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tenor Sans',
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        blog['hashtags']
                            .map<Widget>((tag) => _HashtagChip(text: tag))
                            .toList(),
                  ),
                ),
                Text(
                  blog['date'],
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontFamily: 'Tenor Sans',
                    fontSize: 12,
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

class _CategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _CategoryChip({required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tenor Sans',
          fontSize: 14,
          color: isSelected ? const Color(0xFFDD8560) : const Color(0xFF333333),
        ),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}

class _HashtagChip extends StatelessWidget {
  final String text;

  const _HashtagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 12,
          fontFamily: 'Tenor Sans',
        ),
      ),
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: Color(0xFFF5F5F5)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
