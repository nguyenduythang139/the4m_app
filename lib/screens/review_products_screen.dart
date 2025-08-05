import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewProductScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> product;

  const ReviewProductScreen({
    super.key,
    required this.orderId,
    required this.product,
  });

  @override
  State<ReviewProductScreen> createState() => _ReviewProductScreenState();
}

class _ReviewProductScreenState extends State<ReviewProductScreen> {
  int rating = 5;
  final TextEditingController _reviewController = TextEditingController();
  bool submitting = false;
  int currentLength = 0;
  String? avatarPath; // <-- thêm dòng này

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {
        currentLength = _reviewController.text.length;
      });
    });

    _loadLocalAvatar(); // <-- gọi hàm load avatar
  }

  Future<void> _loadLocalAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('avatar_path');
    setState(() {
      avatarPath = path;
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    if (submitting) return;

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng viết đánh giá")));
      return;
    }

    setState(() => submitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Bạn chưa đăng nhập")));
        setState(() => submitting = false);
        return;
      }

      // Lấy thông tin người dùng từ Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('KhachHang')
              .doc(user.uid)
              .get();

      final data = userDoc.data() ?? {};

      final userName = data['hoTen'] ?? 'Người dùng';
      final avatarUrl = avatarPath ?? 'lib/assets/images/avatar.png';

      final reviewData = {
        'orderId': widget.orderId,
        'productId': widget.product['maSP'],
        'tenSP': widget.product['tenSP'],
        'rating': rating,
        'review': _reviewController.text.trim(),
        'createdAt': Timestamp.now(),
        'hinhAnh': widget.product['hinhAnh'],
        'size': widget.product['kichThuoc'] ?? '',
        'color': widget.product['mauSac'] ?? '',
        'title': "Đánh giá sản phẩm",
        'userName': userName,
        'avatarUrl': avatarUrl,
      };

      await FirebaseFirestore.instance.collection('DanhGia').add(reviewData);

      // Cập nhật trạng thái đã đánh giá trong đơn hàng
      await FirebaseFirestore.instance
          .collection('DonHang')
          .doc(widget.orderId)
          .update({
            'sanPham': FieldValue.arrayRemove([widget.product]),
          });

      final updatedProduct = {...widget.product, 'daDanhGia': true};

      await FirebaseFirestore.instance
          .collection('DonHang')
          .doc(widget.orderId)
          .update({
            'sanPham': FieldValue.arrayUnion([updatedProduct]),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gửi đánh giá thành công")));

      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi gửi đánh giá: $e")));
    } finally {
      setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Đánh giá sản phẩm"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body:
          submitting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thông tin sản phẩm (có khung và bóng)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product['hinhAnh'] ??
                                  'assets/images/no_image.png',
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['tenSP'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Size: ${product['kichThuoc'] ?? 'N/A'} - Màu: ${product['mauSac'] ?? ''}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'vi_VN',
                                        symbol: '₫',
                                      ).format(product['gia']),
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Text(
                                      "x${product['soLuong'] ?? 1}",
                                    ), // hoặc bạn có thể để 'x${product['soLuong']}' nếu cần
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Center(
                      child: Text(
                        "Đánh giá sản phẩm này",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return IconButton(
                            iconSize: 36.0,
                            icon: Icon(
                              index < rating
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: Colors.amber,
                            ),
                            onPressed: () => setState(() => rating = index + 1),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Nhập nhận xét
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _reviewController,
                            maxLines: 5,
                            maxLength: 300,
                            decoration: const InputDecoration(
                              hintText:
                                  "Bạn thích hoặc không thích điều gì về sản phẩm này?",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                40,
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 12,
                          child: Text(
                            "$currentLength/300",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitting ? null : () => submitReview(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Gửi đánh giá",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
