import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = [];
  final List<String> popularSearches = [
    'Áo thun nam',
    'Nón kết',
    'Quần short',
    'Áo thun cổ tròn',
    'Áo chống tia UV',
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('recentSearches');
    if (saved != null && mounted) {
      setState(() {
        recentSearches.clear();
        recentSearches.addAll(saved);
      });
    }
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recentSearches', recentSearches);
  }

  Future<void> _handleSearch([String? input]) async {
    final query = (input ?? _searchController.text).trim().toLowerCase();
    if (query.isEmpty) return;

    if (!recentSearches.map((e) => e.toLowerCase()).contains(query)) {
      setState(() => recentSearches.insert(0, query));
      await _saveRecentSearches();
    }

    setState(() {
      isLoading = true;
      searchResults = [];
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('SanPham')
              .limit(100)
              .get();

      final allProducts =
          snapshot.docs.map((doc) => {...doc.data(), 'maSP': doc.id}).toList();

      final filtered =
          allProducts.where((product) {
            final tenSP = (product['tenSP'] ?? '').toString().toLowerCase();
            final loaiSP = (product['loaiSP'] ?? '').toString().toLowerCase();
            return tenSP.contains(query) || loaiSP.contains(query);
          }).toList();

      if (!mounted) return;
      setState(() => searchResults = filtered);
    } catch (e) {
      debugPrint('Lỗi tìm kiếm: $e');
    }

    if (!mounted) return;
    setState(() => isLoading = false);
    FocusScope.of(context).unfocus();
  }

  void _removeSearchItem(String item) async {
    setState(() => recentSearches.remove(item));
    await _saveRecentSearches();
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tenor Sans',
        color: Color(0xFFDD8560),
      ),
    ),
  );

  Widget _buildGridItem(Map<String, dynamic> productData) {
    final hinhAnh = productData['hinhAnh'];
    String? imagePath;

    if (hinhAnh is String && hinhAnh.isNotEmpty) {
      imagePath = hinhAnh;
    } else if (hinhAnh is List && hinhAnh.isNotEmpty && hinhAnh[0] is String) {
      imagePath = hinhAnh[0];
    }

    bool isFavorited = false;

    return StatefulBuilder(
      builder: (context, setStateLocal) {
        return GestureDetector(
          onTap: () {
            final product = Product.fromMap(
              productData,
              productData['maSP'] ?? '',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    imagePath != null
                        ? (imagePath.startsWith('http')
                            ? Image.network(
                              imagePath,
                              height: 220,
                              width: 165,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 220,
                                    width: 165,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                            )
                            : Image.asset(
                              imagePath,
                              height: 220,
                              width: 165,
                              fit: BoxFit.cover,
                            ))
                        : Container(
                          height: 220,
                          width: 165,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setStateLocal(() => isFavorited = !isFavorited);
                        },
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.orange,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productData['tenSP'] ?? 'Không có tên',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Tenor Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${productData['giaMoi'] ?? '0'} VND',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.orange,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black87),
                      onPressed: () => _handleSearch(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Bạn đang tìm sản phẩm gì?',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                            fontFamily: 'Tenor Sans',
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Tenor Sans',
                          color: Colors.black,
                        ),
                        onSubmitted: _handleSearch,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black54),
                        onPressed:
                            () => setState(() => _searchController.clear()),
                      ),
                  ],
                ),
              ),
            ),

            // Nội dung
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (recentSearches.isNotEmpty) ...[
                            _buildSectionTitle('Đã tìm gần đây'),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children:
                                  recentSearches.map((item) {
                                    return InputChip(
                                      label: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Tenor Sans',
                                        ),
                                      ),
                                      backgroundColor: const Color(0xFFEFEFEF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      onPressed: () => _handleSearch(item),
                                      onDeleted: () => _removeSearchItem(item),
                                    );
                                  }).toList(),
                            ),
                          ] else ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Chưa có lịch sử tìm kiếm.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                          _buildSectionTitle('Tìm kiếm phổ biến'),
                          ...popularSearches.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(
                                  vertical: -2,
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Tenor Sans',
                                  ),
                                ),
                                onTap: () => _handleSearch(item),
                              ),
                            ),
                          ),
                          if (searchResults.isNotEmpty) ...[
                            _buildSectionTitle('Kết quả tìm kiếm'),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: searchResults.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 165 / 300,
                                  ),
                              itemBuilder:
                                  (context, index) =>
                                      _buildGridItem(searchResults[index]),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // TODO: Handle navigation if needed
        },
      ),
    );
  }
}
