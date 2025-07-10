import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/product.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/footer.dart';
import 'package:the4m_app/widgets/header.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedPage = "Mua sắm";
  int currentIndex = 2;
  int selectedIndex = 2;

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  final int itemsPerPage = 8;
  int currentPage = 1;
  List<DocumentSnapshot> allDocs = [];
  List<Product> paginatedProducts = [];
  bool isLoading = false;

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
      // Bước 1: Lấy tổng số lượng sản phẩm (1 lần duy nhất hoặc mỗi lần load)
      final totalSnapshot =
          await FirebaseFirestore.instance.collection('SanPham').get();
      final totalCount = totalSnapshot.docs.length;

      // Bước 2: Lấy sản phẩm theo trang hiện tại
      Query query = FirebaseFirestore.instance
          .collection('SanPham')
          .orderBy('tenSP')
          .limit(itemsPerPage * currentPage); // lấy đủ để phân trang

      final snapshot = await query.get();
      final allDocsTemp = snapshot.docs;

      final currentDocs = allDocsTemp
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage);

      setState(() {
        allDocs = totalSnapshot.docs;
        paginatedProducts =
            currentDocs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Product.fromMap(data, doc.id);
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  int get totalPages => (allDocs.length / itemsPerPage).ceil();

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
            isLoading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          itemCount: paginatedProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                mainAxisExtent: 310,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            final product = paginatedProducts[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: AspectRatio(
                                        aspectRatio: 0.8,
                                        child: Image.asset(
                                          product.hinhAnh[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.favorite_border,
                                          size: 25,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Expanded(
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
                                const SizedBox(height: 2),
                                Text(
                                  product.moTa,
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
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Nút << (Trái)
                              GestureDetector(
                                onTap: () {
                                  if (currentPage > 1) {
                                    setState(() {
                                      currentPage--;
                                    });
                                    fetchPageData();
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () => {},
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              // Danh sách trang
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
                              // Nút >> (Phải)
                              GestureDetector(
                                onTap: () {
                                  if (currentPage < totalPages) {
                                    setState(() {
                                      currentPage++;
                                    });
                                    fetchPageData();
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () => {},
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
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
        onTap:
            (index) => {
              setState(() {
                selectedIndex = index;
              }),
            },
      ),
    );
  }
}
