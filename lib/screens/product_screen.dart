import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/screens/product_detail_screen.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/header.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedPage = "Mua sắm";
  Set<String> favoriteProductIds = {};

  int selectedIndex = 2;

  final int itemsPerPage = 10;
  int currentPage = 1;
  List<DocumentSnapshot> allDocs = [];
  List<Product> paginatedProducts = [];
  bool isLoading = false;
  bool isGridView = true;

  // Bộ lọc loại sản phẩm
  List<String> selectedProductFilters = ['Tất cả sản phẩm'];
  final List<String> availableProductFilters = ['Áo', 'Quần', 'Nón'];

  // Bộ lọc sắp xếp (mặc định: Mới nhất)
  String selectedSortOption = 'Mới nhất';
  final List<String> sortOptions = [
    'Mới nhất',
    'Cũ nhất',
    'Giá tăng dần',
    'Giá giảm dần',
  ];

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPageData();
    });
  }

  Future<void> fetchPageData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance.collection('SanPham');

      // Sắp xếp luôn thực hiện trước để tránh lỗi truy vấn
      if (selectedSortOption == 'Giá tăng dần') {
        query = query.orderBy('giaMoi', descending: false);
      } else if (selectedSortOption == 'Giá giảm dần') {
        query = query.orderBy('giaMoi', descending: true);
      } else if (selectedSortOption == 'Mới nhất') {
        query = query.orderBy('ngayNhapSP', descending: true);
      } else if (selectedSortOption == 'Cũ nhất') {
        query = query.orderBy('ngayNhapSP', descending: false);
      }

      final snapshot = await query.get();
      List<DocumentSnapshot> allDocsTemp = snapshot.docs;

      // Xử lý lọc theo loại sản phẩm ở client (do Firestore hạn chế kết hợp whereIn + orderBy)
      if (selectedProductFilters.isNotEmpty &&
          !(selectedProductFilters.length == 1 &&
              selectedProductFilters[0] == 'Tất cả sản phẩm')) {
        final filters =
            selectedProductFilters
                .where((f) => f != 'Tất cả sản phẩm')
                .toList();

        allDocsTemp =
            allDocsTemp.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return filters.contains(data['loaiSPTQ']);
            }).toList();
      }

      // Phân trang
      final start = (currentPage - 1) * itemsPerPage;
      final end = start + itemsPerPage;
      final currentDocs = allDocsTemp.sublist(
        start,
        end > allDocsTemp.length ? allDocsTemp.length : end,
      );

      setState(() {
        allDocs = allDocsTemp;
        paginatedProducts =
            currentDocs
                .map(
                  (doc) => Product.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi fetch data: $e");
      if (e is FirebaseException) {
        print("FirebaseException: ${e.message}");
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  int get totalPages => (allDocs.length / itemsPerPage).ceil();

  Widget buildProductItem(Product product, {bool isList = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Stack(
          children: [
            isList
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          product.hinhAnh[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ), // tạo khoảng cách tránh đè lên icon
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth:
                                    170, // giới hạn chiều ngang để giảm số chữ 1 dòng
                              ),
                              child: Text(
                                product.tenSP,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),
                            Text(
                              product.moTa,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatCurrency(product.giaMoi),
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 0.7,
                        child: Image.asset(
                          product.hinhAnh[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ), // tạo khoảng cách tránh đè lên icon
                          Text(
                            product.tenSP,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.moTa,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatCurrency(product.giaMoi),
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (favoriteProductIds.contains(product.maSP)) {
                      favoriteProductIds.remove(product.maSP);
                    } else {
                      favoriteProductIds.add(product.maSP);
                    }
                  });
                },
                child: Icon(
                  favoriteProductIds.contains(product.maSP)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 24,
                  color:
                      favoriteProductIds.contains(product.maSP)
                          ? Colors.orange
                          : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    "${allDocs.length} SẢN PHẨM",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  // Dropdown sắp xếp
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true,
                        value: selectedSortOption,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        items:
                            sortOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSortOption = newValue;
                              currentPage = 1;
                            });
                            fetchPageData();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Dropdown loại sản phẩm
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.orange,
                        size: 20,
                      ),
                      onSelected: (String newValue) {
                        if (!selectedProductFilters.contains(newValue)) {
                          setState(() {
                            selectedProductFilters.remove('Tất cả sản phẩm');
                            selectedProductFilters.add(newValue);
                            currentPage = 1;
                          });
                          fetchPageData();
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return availableProductFilters
                            .where(
                              (item) => !selectedProductFilters.contains(item),
                            )
                            .map((String value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList();
                      },
                    ),
                  ),

                  const SizedBox(width: 6),
                  // Toggle View
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        setState(() {
                          isGridView = !isGridView;
                        });
                      },
                      child: Center(
                        // đảm bảo icon nằm giữa
                        child: Icon(
                          isGridView ? Icons.view_list : Icons.grid_view,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Chip filter đang chọn
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(selectedSortOption),
                        backgroundColor: Colors.orange.shade300,
                        shape: StadiumBorder(
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            selectedSortOption = 'Mới nhất';
                            currentPage = 1;
                          });
                          fetchPageData();
                        },
                      ),
                      const SizedBox(width: 8),
                      ...selectedProductFilters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(filter),
                            backgroundColor:
                                filter == 'Tất cả sản phẩm'
                                    ? Colors.white
                                    : Colors.orange.shade300,
                            shape: StadiumBorder(
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() {
                                selectedProductFilters.remove(filter);
                                if (selectedProductFilters.isEmpty) {
                                  selectedProductFilters.add('Tất cả sản phẩm');
                                }
                                currentPage = 1;
                              });
                              fetchPageData();
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        isGridView
                            ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: paginatedProducts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 350,
                                    mainAxisExtent: 360,
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3,
                                  ),
                              itemBuilder: (context, index) {
                                return buildProductItem(
                                  paginatedProducts[index],
                                );
                              },
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paginatedProducts.length,
                              itemBuilder: (context, index) {
                                return buildProductItem(
                                  paginatedProducts[index],
                                  isList: true,
                                );
                              },
                            ),
                        // Pagination
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (currentPage > 1) {
                                    setState(() {
                                      currentPage--;
                                    });
                                    fetchPageData();
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              ...List.generate(totalPages, (index) {
                                final page = index + 1;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentPage = page;
                                    });
                                    fetchPageData();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 12,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          currentPage == page
                                              ? Colors.black
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Text(
                                      '$page',
                                      style: TextStyle(
                                        color:
                                            currentPage == page
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              GestureDetector(
                                onTap: () {
                                  if (currentPage < totalPages) {
                                    setState(() {
                                      currentPage++;
                                    });
                                    fetchPageData();
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Footer(),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
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
