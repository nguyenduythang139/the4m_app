import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the4m_app/models/cart.dart';
import 'package:the4m_app/models/delivery_method_model.dart';
import 'package:the4m_app/models/payment_method_model.dart';
import 'package:the4m_app/models/voucher.dart';
import 'package:the4m_app/screens/account_screen.dart';
import 'package:the4m_app/screens/add_address_screen.dart';
import 'package:the4m_app/screens/blog_screen.dart';
import 'package:the4m_app/screens/complete_order_screen.dart';
import 'package:the4m_app/screens/contact_screen.dart';
import 'package:the4m_app/screens/favorite_screen.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/our_story_screen.dart';
import 'package:the4m_app/screens/voucher_screen.dart';
import 'package:the4m_app/services/MomoPaymentService.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/cart_notify.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/drawer.dart';
import 'package:the4m_app/widgets/header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final List<Cart> cartList;
  final Voucher? selectedVoucher;
  final int totalAmount;
  final int total;
  final int discount;
  final int tax;
  final int quantityProduct;

  const PaymentScreen({
    super.key,
    required this.cartList,
    required this.selectedVoucher,
    required this.totalAmount,
    required this.total,
    required this.discount,
    required this.tax,
    required this.quantityProduct,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Voucher? _selectedVoucher;
  int shippingFee = 40000;

  final List<DeliveryMethodOption> deliveryMethods = [
    DeliveryMethodOption(name: 'Chuyển phát nhanh', price: '40.000 VNĐ'),
    DeliveryMethodOption(name: 'Giao tiêu chuẩn', price: '20.000 VNĐ'),
    DeliveryMethodOption(name: 'Giao tiết kiệm', price: 'MIỄN PHÍ'),
  ];

  DeliveryMethodOption? selectedDeliveryMethod;

  final List<PaymentMethodOption> paymentMethods = [
    PaymentMethodOption(name: 'Thanh toán bằng vnpay'),
    PaymentMethodOption(name: 'Thanh toán bằng momo'),
    PaymentMethodOption(name: 'Thanh toán tiền mặt'),
  ];

  PaymentMethodOption? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    selectedDeliveryMethod = deliveryMethods.first;
    selectedPaymentMethod = paymentMethods.first;
    _selectedVoucher = widget.selectedVoucher;
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  String? hoTen;
  String? diaChi;
  String? soDienThoai;
  String? thanhPho;
  String? phuong;

  Future<void> saveOrder({
    required List<Cart> cartList,
    required int tongSoLuong,
    required int tongTien,
    required int phiGiaoHang,
    required int thue,
    required int? giamGia,
    required int thanhTien,
    required String? maVoucher,
    required String hoTen,
    required String soDienThoai,
    required String diaChi,
    required String phuong,
    required String thanhPho,
    required String phuongThucThanhToan,
    required String phuongThucGiaoHang,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final maDH = "DH_${DateTime.now().millisecondsSinceEpoch}";

    final productList =
        cartList
            .map(
              (cart) => {
                "maSP": cart.maSP,
                "tenSP": cart.tenSP,
                "gia": cart.gia,
                "hinhAnh": cart.hinhAnh,
                "soLuong": cart.soLuong,
                "kichThuoc": cart.kichThuoc,
                "mauSac": cart.mauSac,
              },
            )
            .toList();

    await FirebaseFirestore.instance.collection('DonHang').doc(maDH).set({
      "maDH": maDH,
      "maKH": user.uid,
      "tongSoLuong": tongSoLuong,
      "tongTien": tongTien,
      "phiGiaoHang": phiGiaoHang,
      "thue": thue,
      "giamGia": giamGia,
      "thanhTien": thanhTien,
      "maVoucher": maVoucher,
      "trangThai": "Đang giao",
      "ngayDat": FieldValue.serverTimestamp(),
      "sanPham": productList,
      "thongTinGiaoHang": {
        "hoTen": hoTen,
        "soDienThoai": soDienThoai,
        "diaChi": diaChi,
        "phuong": phuong,
        "thanhPho": thanhPho,
      },
      "phuongThucThanhToan": phuongThucThanhToan,
      "phuongThucGiaoHang": phuongThucGiaoHang,
    });
  }

  Future<void> clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('TaiKhoan')
        .doc(user.uid)
        .collection('GioHang');

    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await cartRef.doc(doc.id).delete();
    }

    cartNotify.updateCount(0);
  }

  Future<String> createPaymentUrl(int amount, String orderId) async {
    final uri = Uri.parse(
      'http://192.168.102.6:3000/api/payments/create_payment_url',
    );
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'orderId': orderId,
        'orderInfo': 'Thanh toán đơn hàng $orderId',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['paymentUrl'];
    } else {
      throw Exception('Không thể tạo URL thanh toán');
    }
  }

  Future<void> openPayment(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không mở được link thanh toán');
    }
  }

  Future<bool> checkOrderPaid(String orderId) async {
    final uri = Uri.parse(
      'http://192.168.102.6:3000/api/payments/order_status/$orderId',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == 'paid';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: "",
        onSelect: (selected) {
          smoothPushReplacementLikePush(context, getPageFromLabel(selected));
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "THANH TOÁN",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "TenorSans",
                                  ),
                                ),
                                Devider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            ...List.generate(5, (index) => dotLine()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.credit_card,
                              color: Colors.orange,
                              size: 25,
                            ),
                            SizedBox(width: 5),
                            ...List.generate(5, (index) => dotLine()),
                            SizedBox(width: 5),
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xffC8C7CC),
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Thong tin don hang
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "THÔNG TIN GIAO HÀNG",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              final addressData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAddressScreen(),
                                ),
                              );
                              if (addressData != null) {
                                setState(() {
                                  hoTen = addressData['hoTen'];
                                  diaChi = addressData['diaChi'];
                                  soDienThoai = addressData['soDienThoai'];
                                  thanhPho = addressData['thanhPho'];
                                  phuong = addressData['phuong'];
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hoTen ?? "Họ tên người nhận:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        diaChi ?? "Địa chỉ:",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "NotoSerif_2",
                                          color: Color(0xff555555),
                                        ),
                                      ),
                                      Text(
                                        "$phuong, $thanhPho" ??
                                            "Phường - Thành phố:",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "NotoSerif_2",
                                          color: Color(0xff555555),
                                        ),
                                      ),
                                      Text(
                                        soDienThoai ?? "Số điện thoại:",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "NotoSerif_2",
                                          color: Color(0xff555555),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                          // Chon phuong thuc van chuyen
                          SizedBox(height: 20),
                          Text(
                            "PHƯƠNG THỨC VẬN CHUYỂN",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<DeliveryMethodOption>(
                            dropdownColor: Colors.white,
                            value: selectedDeliveryMethod,
                            items:
                                deliveryMethods.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            method.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "NotoSerif_2",
                                              color: Color(0xff555555),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          method.price,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "NotoSerif_2",
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDeliveryMethod = value!;
                                if (value.name == "Chuyển phát nhanh") {
                                  shippingFee = 40000;
                                } else if (value.name == "Giao tiêu chuẩn") {
                                  shippingFee = 20000;
                                } else {
                                  shippingFee = 0;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return deliveryMethods.map((method) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      method.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "NotoSerif_2",
                                        color: Color(0xff555555),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "-",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      method.price,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "NotoSerif_2",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                          SizedBox(height: 20),
                          // Chon phuong thuc thanh toan
                          Text(
                            "PHƯƠNG THỨC THANH TOÁN",
                            style: TextStyle(
                              fontFamily: "NotoSerif_2",
                              fontSize: 15,
                              color: Color(0xff555555),
                            ),
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<PaymentMethodOption>(
                            dropdownColor: Colors.white,
                            value: selectedPaymentMethod,
                            items:
                                paymentMethods.map((method) {
                                  return DropdownMenuItem(
                                    value: method,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            method.name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "NotoSerif_2",
                                              color: Color(0xff555555),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.orange,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return paymentMethods.map((method) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      method.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "NotoSerif_2",
                                        color: Color(0xff555555),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                          // Tong tien
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "TỔNG ĐƠN HÀNG | ${widget.quantityProduct} SẢN PHẨM",
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tổng cộng"),
                                      Text(
                                        "${formatCurrency(widget.total)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Phiếu giảm giá"),
                                      Text(
                                        _selectedVoucher != null
                                            ? "- ${formatCurrency(_selectedVoucher!.giaTri)}"
                                            : "- 0 VNĐ",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Đã bao gồm thuế"),
                                      Text("${formatCurrency(widget.tax)}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tiền vận chuyển"),
                                      Text("${formatCurrency(shippingFee)}"),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "THÀNH TIỀN:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${formatCurrency(widget.totalAmount + shippingFee)}",
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          // Thong tin phieu giam gia
                          _selectedVoucher == null
                              ? GestureDetector(
                                onTap: () async {
                                  final voucher = await Navigator.push<Voucher>(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => VoucherScreen(
                                            totalAmount: widget.totalAmount,
                                          ),
                                    ),
                                  );
                                  if (voucher != null) {
                                    setState(() {
                                      _selectedVoucher = voucher;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.confirmation_num),
                                          SizedBox(width: 10),
                                          Text("PHIẾU GIẢM GIÁ"),
                                        ],
                                      ),
                                      Icon(Icons.keyboard_arrow_right),
                                    ],
                                  ),
                                ),
                              )
                              : Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final voucher =
                                              await Navigator.push<Voucher>(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => VoucherScreen(
                                                        totalAmount:
                                                            widget.totalAmount,
                                                      ),
                                                ),
                                              );
                                          if (voucher != null) {
                                            setState(() {
                                              _selectedVoucher = voucher;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.edit, size: 18),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.confirmation_num,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "PHIẾU GIẢM GIÁ",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "NotoSerif_2",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "• ",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _selectedVoucher!
                                                        .tenVoucher,
                                                    style: TextStyle(
                                                      fontFamily: "NotoSerif_2",
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    "Ngày kết thúc: ${DateFormat('dd/MM/yyyy hh:mm a').format(_selectedVoucher!.ngayKetThuc)}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                      fontFamily: "NotoSerif_2",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedVoucher = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 3,
                                                  horizontal: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text("Xóa"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () async {
            for (final cart in widget.cartList) {
              final variantSnapshot =
                  await FirebaseFirestore.instance
                      .collection('SanPham')
                      .doc(cart.maSP)
                      .collection('bienThe')
                      .where('mauSac', isEqualTo: cart.mauSac)
                      .where('kichThuoc', isEqualTo: cart.kichThuoc)
                      .limit(1)
                      .get();

              if (variantSnapshot.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Sản phẩm ${cart.tenSP} không tồn tại."),
                  ),
                );
                return;
              }

              final stock = variantSnapshot.docs.first['soLuong'] ?? 0;
              if (cart.soLuong > stock) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Sản phẩm ${cart.tenSP} (Size ${cart.kichThuoc}, Màu ${cart.mauSac}) chỉ còn $stock cái trong kho",
                    ),
                  ),
                );
                return;
              }
            }

            // Nếu qua hết check thì mới lưu đơn và trừ tồn kho
            for (final cart in widget.cartList) {
              final variantDoc =
                  await FirebaseFirestore.instance
                      .collection('SanPham')
                      .doc(cart.maSP)
                      .collection('bienThe')
                      .where('mauSac', isEqualTo: cart.mauSac)
                      .where('kichThuoc', isEqualTo: cart.kichThuoc)
                      .limit(1)
                      .get();

              final docId = variantDoc.docs.first.id;
              final currentStock = variantDoc.docs.first['soLuong'] ?? 0;
              await FirebaseFirestore.instance
                  .collection('SanPham')
                  .doc(cart.maSP)
                  .collection('bienThe')
                  .doc(docId)
                  .update({'soLuong': currentStock - cart.soLuong});
            }
            if (hoTen == null ||
                hoTen!.isEmpty ||
                diaChi == null ||
                diaChi!.isEmpty ||
                soDienThoai == null ||
                soDienThoai!.isEmpty ||
                thanhPho == null ||
                thanhPho!.isEmpty ||
                phuong == null ||
                phuong!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Vui lòng nhập đầy đủ thông tin giao hàng."),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            if (selectedPaymentMethod?.name == "Thanh toán bằng momo") {
              await MoMoPaymentService().createPayment(1000);
            } else if (selectedPaymentMethod?.name == "Thanh toán bằng vnpay") {
              final orderId = "CASH_${DateTime.now().millisecondsSinceEpoch}";
              final url = await createPaymentUrl(
                widget.totalAmount + shippingFee,
                orderId,
              );
              await openPayment(url);

              await saveOrder(
                cartList: widget.cartList,
                tongSoLuong: widget.quantityProduct,
                tongTien: widget.total,
                phiGiaoHang: shippingFee,
                thue: widget.tax,
                giamGia: widget.discount,
                thanhTien: widget.totalAmount + shippingFee,
                maVoucher: widget.selectedVoucher?.maVoucher,
                hoTen: hoTen!,
                soDienThoai: soDienThoai!,
                diaChi: diaChi!,
                phuong: phuong!,
                thanhPho: thanhPho!,
                phuongThucThanhToan: selectedPaymentMethod!.name,
                phuongThucGiaoHang: selectedDeliveryMethod!.name,
              );

              await clearCart();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CompleteOrderScreen(
                        orderId:
                            "CASH_${DateTime.now().millisecondsSinceEpoch}",
                        totalAmount: widget.totalAmount + shippingFee,
                        selectedPaymentMethod: selectedPaymentMethod!.name,
                      ),
                ),
              );
            } else if (selectedPaymentMethod?.name == "Thanh toán tiền mặt") {
              await saveOrder(
                cartList: widget.cartList,
                tongSoLuong: widget.quantityProduct,
                tongTien: widget.total,
                phiGiaoHang: shippingFee,
                thue: widget.tax,
                giamGia: widget.discount,
                thanhTien: widget.totalAmount + shippingFee,
                maVoucher: widget.selectedVoucher?.maVoucher,
                hoTen: hoTen!,
                soDienThoai: soDienThoai!,
                diaChi: diaChi!,
                phuong: phuong!,
                thanhPho: thanhPho!,
                phuongThucThanhToan: selectedPaymentMethod!.name,
                phuongThucGiaoHang: selectedDeliveryMethod!.name,
              );

              await clearCart();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => CompleteOrderScreen(
                        orderId:
                            "CASH_${DateTime.now().millisecondsSinceEpoch}",
                        totalAmount: widget.totalAmount + shippingFee,
                        selectedPaymentMethod: selectedPaymentMethod!.name,
                      ),
                ),
              );
            }

            // final payUrl = await MoMoPaymentService().createPayment(50000);
            // if (payUrl != null) {
            //   final result = await Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => MomoWebViewScreen(payUrl: payUrl),
            //     ),
            //   );
            //   if (result == true) {
            //     // Thanh toán xong → chuyển sang màn hình hoàn tất
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => const CompleteOrderScreen(orderId: "123"),
            //       ),
            //     );
            //   }
            // }
          },
          icon: const Icon(Icons.credit_score_rounded, color: Colors.white),
          label: const Text(
            "HOÀN TẤT ĐẶT HÀNG",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "TenorSans",
            ),
          ),
        ),
      ),
    );
  }
}

Widget dotLine() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Color(0xffC8C7CC),
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget getPageFromLabel(String label) {
  switch (label) {
    case "Trang chủ":
      return HomeScreen();
    case "Yêu thích":
      return FavoriteScreen();
    case "Tài khoản":
      return Account_Screen();
    case "Thông tin":
      return OurStoryScreen();
    case "Liên lạc":
      return ContactScreen();
    case "Blog":
      return BlogScreen();
    default:
      return HomeScreen();
  }
}
