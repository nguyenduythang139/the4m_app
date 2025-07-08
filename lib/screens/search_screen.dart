import 'package:flutter/material.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> recentSearches = []; // Sản phẩm đã tìm
  final List<String> popularSearches = [
    'Áo thun nam',
    'Nón kết',
    'Quần short',
    'Áo thun cổ tròn',
    'Áo chống tia UV',
  ];

  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        // Thêm vào danh sách nếu chưa có
        if (!recentSearches.contains(query)) {
          recentSearches.insert(0, query);
        }
      });
      _searchController.clear();
      FocusScope.of(context).unfocus(); // Ẩn bàn phím
      print('Đã tìm kiếm: $query');
      // TODO: Gọi API hoặc hiển thị kết quả tìm kiếm nếu cần
    }
  }

  void _removeSearchItem(String item) {
    setState(() {
      recentSearches.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 36, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: _handleSearch,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Bạn đang tìm sản phẩm gì?',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Tenor Sans',
                        color: Color(0xFF555555),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Tenor Sans',
                      color: Colors.black,
                    ),
                    onSubmitted: (_) => _handleSearch(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () => _searchController.clear(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Sản phẩm đã tìm',
              style: TextStyle(
                color: Color(0xFFDD8560),
                fontSize: 14,
                fontFamily: 'Tenor Sans',
              ),
            ),
            const SizedBox(height: 8),
            if (recentSearches.isEmpty)
              const Text(
                'Chưa có sản phẩm nào được tìm.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  recentSearches
                      .map(
                        (item) => _SearchChip(
                          label: item,
                          onDeleted: () => _removeSearchItem(item),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tìm kiếm phổ biến',
              style: TextStyle(
                color: Color(0xFFDD8560),
                fontSize: 14,
                fontFamily: 'Tenor Sans',
              ),
            ),
            const SizedBox(height: 8),
            ...popularSearches.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Tenor Sans',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Xử lý điều hướng nếu cần
        },
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const _SearchChip({required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: const Color(0x33C4C4C4),
      shape: const StadiumBorder(),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontFamily: 'Tenor Sans',
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.black54),
      onDeleted: onDeleted,
    );
  }
}
