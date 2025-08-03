import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher {
  final String maVoucher;
  final String tenVoucher;
  final int giaTri;
  final int giaTriDieuKien;
  final String dieuKien;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final String thongTin;

  Voucher({
    required this.maVoucher,
    required this.tenVoucher,
    required this.giaTri,
    required this.giaTriDieuKien,
    required this.dieuKien,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.thongTin,
  });

  factory Voucher.fromFirestore(Map<String, dynamic> data, String id) {
    return Voucher(
      maVoucher: id,
      tenVoucher: data['tenVoucher'] ?? '',
      giaTri: (data['giaTri'] ?? 0).toInt(),
      giaTriDieuKien: (data['giaTriDieuKien'] ?? 0).toInt(),
      dieuKien: data['dieuKien'] ?? '',
      ngayBatDau: (data['ngayBatDau'] as Timestamp).toDate(),
      ngayKetThuc: (data['ngayKetThuc'] as Timestamp).toDate(),
      thongTin: data['thongTin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maVoucher': maVoucher,
      'tenVoucher': tenVoucher,
      'giaTri': giaTri,
      'giaTriDieuKien': giaTriDieuKien,
      'dieuKien': dieuKien,
      'ngayBatDau': Timestamp.fromDate(ngayBatDau),
      'ngayKetThuc': Timestamp.fromDate(ngayKetThuc),
      'thongTin': thongTin,
    };
  }
}
