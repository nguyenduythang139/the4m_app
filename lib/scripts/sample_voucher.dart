import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSampleVoucher() async {
  final firestore = FirebaseFirestore.instance;

  final vouchers = [
    {
      "tenVoucher": "GIẢM 50K CHO ĐƠN TỪ 499K",
      "giaTri": 50000,
      "dieuKien": "Áp dụng cho đơn hàng có giá trị từ 499,000 VNĐ trở lên",
      "giaTriDieuKien": 499000,
      "ngayBatDau": "2025-07-10T00:00:00.000Z",
      "ngayKetThuc": "2025-07-31T23:59:59.000Z",
      "thongTin":
          "- Áp dụng cho toàn bộ sản phẩm tại hệ thống 4M\n- Mỗi khách hàng chỉ sử dụng tối đa 1 lần\n- Không áp dụng đồng thời với các chương trình khuyến mãi khác\n- Voucher không có giá trị quy đổi thành tiền mặt",
    },
  ];

  for (var voucher in vouchers) {
    final docRef = await firestore.collection("Voucher").add(voucher);
    await firestore.collection("Voucher").doc(docRef.id).update({
      'maVoucher': docRef.id,
    });
  }
}
