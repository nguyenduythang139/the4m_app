class Cart {
  String id;
  String maSP;
  String tenSP;
  String hinhAnh;
  int gia;
  String kichThuoc;
  String mauSac;
  int soLuong;

  Cart({
    required this.id,
    required this.maSP,
    required this.tenSP,
    required this.hinhAnh,
    required this.gia,
    required this.kichThuoc,
    required this.mauSac,
    required this.soLuong,
  });

  factory Cart.fromMap(Map<String, dynamic> map, String documentId) {
    return Cart(
      id: documentId,
      maSP: map['maSP'] ?? '',
      tenSP: map['tenSP'] ?? '',
      hinhAnh: map['hinhAnh'] ?? '',
      gia: map['gia'] ?? 0,
      kichThuoc: map['kichThuoc'] ?? '',
      mauSac: map['mauSac'] ?? '',
      soLuong: map['soLuong'] ?? 0,
    );
  }

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
