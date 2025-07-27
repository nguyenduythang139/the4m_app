class Cart {
  String maSP;
  String tenSP;
  String hinhAnh;
  int gia;
  String kichThuoc;
  String mauSac;
  int soLuong;

  Cart({
    required this.maSP,
    required this.tenSP,
    required this.hinhAnh,
    required this.gia,
    required this.kichThuoc,
    required this.mauSac,
    required this.soLuong,
  });

  Map<String, dynamic> toMap() {
    return {
      'maSP': maSP,
      'tenSP': tenSP,
      'hinhAnh': hinhAnh,
      'gia': gia,
      'kichThuoc': kichThuoc,
      'mauSac': mauSac,
      'soLuong': soLuong,
    };
  }
}
