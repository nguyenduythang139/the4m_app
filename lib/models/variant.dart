class Variant {
  final String id;
  final String mauSac;
  final String kichThuoc;
  int soLuong;

  Variant({
    required this.id,
    required this.mauSac,
    required this.kichThuoc,
    required this.soLuong,
  });

  factory Variant.fromMap(Map<String, dynamic> map, String id) {
    return Variant(
      id: id,
      mauSac: map['mauSac'],
      kichThuoc: map['kichThuoc'],
      soLuong: map['soLuong'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'mauSac': mauSac, 'kichThuoc': kichThuoc, 'soLuong': soLuong};
  }
}
