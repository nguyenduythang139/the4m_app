class Product {
  final String maSP;
  final String tenSP;
  final int giaCu;
  final int giaMoi;
  final String moTa;
  final List<String> hinhAnh;
  final String loaiSP;
  final String thuongHieu;
  final String chatLieu;
  final String baoQuan;
  final String thuocTay;
  final String giatKho;
  final String sayKho;
  final String nhietDoUi;
  final String loaiSPTQ;
  bool liked;

  Product({
    required this.maSP,
    required this.tenSP,
    required this.giaCu,
    required this.giaMoi,
    required this.moTa,
    required this.hinhAnh,
    required this.loaiSP,
    required this.thuongHieu,
    required this.chatLieu,
    required this.baoQuan,
    required this.thuocTay,
    required this.giatKho,
    required this.sayKho,
    required this.nhietDoUi,
    required this.loaiSPTQ,
    this.liked = false,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      maSP: id,
      tenSP: map['tenSP'] ?? '',
      giaCu: map['giaCu'] ?? 0,
      giaMoi: map['giaMoi'] ?? 0,
      moTa: map['moTa'] ?? '',
      hinhAnh: map['hinhAnh'] != null ? List<String>.from(map['hinhAnh']) : [],
      loaiSP: map['loaiSP'] ?? '',
      thuongHieu: map['thuongHieu'] ?? '',
      chatLieu: map['chatLieu'] ?? '',
      baoQuan: map['baoQuan'] ?? '',
      thuocTay: map['thuocTay'] ?? '',
      giatKho: map['giatKho'] ?? '',
      sayKho: map['sayKho'] ?? '',
      nhietDoUi: map['nhietDoUi'] ?? '',
      loaiSPTQ: map['loaiSPTQ'] ?? '',
    );
  }
}
