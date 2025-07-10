class Product {
  String maSP;
  String tenSP;
  int giaCu;
  int giaMoi;
  String moTa;
  List<String> hinhAnh;
  List<String> mauSac;
  List<String> kichThuoc;
  String loaiSP;
  String thuongHieu;
  String chatLieu;
  String baoQuan;
  String thuocTay;
  String giatKho;
  String sayKho;
  String nhietDoUi;

  Product({
    required this.maSP,
    required this.tenSP,
    required this.giaCu,
    required this.giaMoi,
    required this.moTa,
    required this.hinhAnh,
    required this.mauSac,
    required this.kichThuoc,
    required this.loaiSP,
    required this.thuongHieu,
    required this.chatLieu,
    required this.baoQuan,
    required this.thuocTay,
    required this.giatKho,
    required this.sayKho,
    required this.nhietDoUi,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      maSP: id,
      tenSP: map['tenSP'],
      giaCu: map['giaCu'],
      giaMoi: map['giaMoi'],
      moTa: map['moTaNgan'],
      hinhAnh: List<String>.from(map['hinhAnh']),
      mauSac: List<String>.from(map['mauSac']),
      kichThuoc: List<String>.from(map['kichThuoc']),
      loaiSP: map['loaiSP'],
      thuongHieu: map['thuongHieu'],
      chatLieu: map['chatLieu'],
      baoQuan: map['baoQuan'],
      thuocTay: map['thuocTay'],
      giatKho: map['giatKho'],
      sayKho: map['sayKho'],
      nhietDoUi: map['nhietDoUi'],
    );
  }
}
