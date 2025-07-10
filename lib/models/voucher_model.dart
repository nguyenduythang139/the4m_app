class Voucher {
  String maVoucher;
  String tenVoucher;
  int giaTri;
  String dieuKien;
  int giaTriDieuKien;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  String thongTin;

  Voucher({
    required this.maVoucher,
    required this.tenVoucher,
    required this.giaTri,
    required this.dieuKien,
    required this.giaTriDieuKien,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.thongTin,
  });

  factory Voucher.fromMap(Map<String, dynamic> map, String id) {
    return Voucher(
      maVoucher: id,
      tenVoucher: map['tenVoucher'],
      giaTri: map['giaTri'],
      dieuKien: map['dieuKien'],
      giaTriDieuKien: map['giaTriDieuKien'],
      ngayBatDau: map['ngayBatDau'],
      ngayKetThuc: map['ngayKetThuc'],
      thongTin: map['thongTin'],
    );
  }
}
