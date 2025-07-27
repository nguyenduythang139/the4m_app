import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the4m_app/models/blog_model.dart';
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
  String selectedPage = "Blogs";
  String? selectedType;
  int selectedIndex = 0;
  late Future<List<BlogModel>> futureBlogs;

  final List<Map<String, String>> categories = [
    {'key': 'thoitrang', 'label': 'Thời Trang'},
    {'key': 'giamgia', 'label': 'Giảm Giá'},
    {'key': 'chinhsach', 'label': 'Chính Sách'},
  ];

  @override
  void initState() {
    super.initState();
    futureBlogs = fetchBlogs();
  }

  Future<List<BlogModel>> fetchBlogs() async {
    Query query = FirebaseFirestore.instance.collection('Blogs');

    if (selectedType != null) {
      query = query.where('blogType', isEqualTo: selectedType);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => BlogModel.fromDoc(doc)).toList();
  }

  void _onCategorySelected(String? type) {
    setState(() {
      selectedType = (selectedType == type) ? null : type;
      futureBlogs = fetchBlogs();
    });
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
      body: FutureBuilder<List<BlogModel>>(
        future: futureBlogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Đã xảy ra lỗi khi tải blog"));
          }

          final blogs = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'BLOG',
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
                _buildCategoryTabs(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      blogs.isEmpty
                          ? const Center(child: Text("Không có blog nào"))
                          : Column(
                            children:
                                blogs
                                    .map(
                                      (blog) => _buildBlogCard(context, blog),
                                    )
                                    .toList(),
                          ),
                ),
                const SizedBox(height: 12),
                _buildXemThemButton(),
                const SizedBox(height: 20),
                const Footer(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            categories.map((category) {
              final isSelected = selectedType == category['key'];
              return GestureDetector(
                onTap: () => _onCategorySelected(category['key']),
                child: _CategoryChip(
                  title: category['label']!,
                  isSelected: isSelected,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildXemThemButton() {
    return Center(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDEDEDE)),
          padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 12),
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
    );
  }

  Widget _buildBlogCard(BuildContext context, BlogModel blog) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlogDetail(
                  imageUrl: blog.image,
                  title: blog.title,
                  hashtags: blog.hashtags,
                  date: blog.date,
                  midImageUrl: blog.midImageUrl,
                  content1: blog.content1,
                  content2: blog.content2,
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
                      image:
                          blog.image.startsWith("http")
                              ? NetworkImage(blog.image)
                              : AssetImage(blog.image) as ImageProvider,
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
                    blog.title,
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
                        blog.hashtags
                            .map((tag) => _HashtagChip(text: tag))
                            .toList(),
                  ),
                ),
                Text(
                  blog.date,
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
