import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSampleProducts() async {
  final firestore = FirebaseFirestore.instance;

  final products = [
    {
      "tenSP": "Áo polo nam thời trang",
      "giaCu": 399000,
      "giaMoi": 279000,
      "moTaNgan": "Kiểu dáng trẻ trung, phù hợp đi làm hoặc đi chơi",
      "kichThuoc": ["M", "L", "XL"],
      "chatLieu":
          "- Cotton cao cấp, thấm hút mồ hôi\n- Thiết kế cổ bẻ cổ điển\n- Dễ phối đồ với nhiều trang phục",
      "baoQuan":
          "- Giặt tay hoặc giặt máy nhẹ\n- Tránh phơi trực tiếp dưới nắng gắt\n- Không dùng thuốc tẩy",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Không sấy khô",
      "nhietDoUi": "110°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_9-1.png",
        "lib/assets/images/product_detail_9-2.png",
        "lib/assets/images/product_detail_9-3.png",
        "lib/assets/images/product_detail_9-4.png",
        "lib/assets/images/product_detail_9-5.png",
      ],
      "mauSac": ["Đen", "Xám"],
      "loaiSP": "Áo polo",
      "thuongHieu": "Gucci",
    },
    {
      "tenSP": "Quần dài nam công sở",
      "giaCu": 599000,
      "giaMoi": 459000,
      "moTaNgan": "Chất vải mềm, co giãn tốt, tôn dáng",
      "kichThuoc": ["30", "32", "34"],
      "chatLieu":
          "- Vải kaki cao cấp\n- Co giãn nhẹ, thoải mái khi vận động\n- Thiết kế form slim-fit sang trọng",
      "baoQuan":
          "- Giặt nước lạnh\n- Không dùng bàn chải cứng\n- Là ủi ở nhiệt độ trung bình",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Sấy nhẹ",
      "nhietDoUi": "140°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_10-1.png",
        "lib/assets/images/product_detail_10-2.png",
        "lib/assets/images/product_detail_10-3.png",
        "lib/assets/images/product_detail_10-4.png",
        "lib/assets/images/product_detail_10-5.png",
      ],
      "mauSac": ["Đen", "Trắng"],
      "loaiSP": "quần dài",
      "thuongHieu": "Prada",
    },
    {
      "tenSP": "Nón lưỡi trai nam logo Gucci",
      "giaCu": 299000,
      "giaMoi": 249000,
      "moTaNgan": "Thiết kế đơn giản, năng động",
      "kichThuoc": ["Free Size"],
      "chatLieu":
          "- Vải cotton chống nắng tốt\n- Đệm đầu mềm mại\n- Lỗ thoáng khí tạo sự dễ chịu",
      "baoQuan":
          "- Không giặt máy\n- Giặt tay nhẹ nhàng\n- Không sử dụng thuốc tẩy",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Phơi khô tự nhiên",
      "nhietDoUi": "Không cần ủi",
      "hinhAnh": [
        "lib/assets/images/product_detail_11-1.png",
        "lib/assets/images/product_detail_11-2.png",
        "lib/assets/images/product_detail_11-3.png",
        "lib/assets/images/product_detail_11-4.png",
        "lib/assets/images/product_detail_11-5.png",
      ],
      "mauSac": ["Đen", "Be"],
      "loaiSP": "nón",
      "thuongHieu": "Gucci",
    },
    {
      "tenSP": "Áo khoác bomber nam cao cấp",
      "giaCu": 899000,
      "giaMoi": 699000,
      "moTaNgan": "Giữ ấm tốt, phong cách Hàn Quốc",
      "kichThuoc": ["M", "L", "XL"],
      "chatLieu":
          "- Chất liệu vải dù chống gió\n- Lớp lót nỉ mềm giữ nhiệt\n- Bo tay và cổ tay co giãn",
      "baoQuan":
          "- Không sấy nhiệt cao\n- Ủi mặt trái của áo\n- Tránh ngâm nước quá lâu",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Có thể giặt khô",
      "sayKho": "Sấy ở nhiệt độ thấp",
      "nhietDoUi": "100°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_12-1.png",
        "lib/assets/images/product_detail_12-2.png",
        "lib/assets/images/product_detail_12-3.png",
        "lib/assets/images/product_detail_12-4.png",
        "lib/assets/images/product_detail_12-5.png",
      ],
      "mauSac": ["Xanh Navy", "Đen"],
      "loaiSP": "Áo khoác",
      "thuongHieu": "Burberrys",
    },
    {
      "tenSP": "Quần jean nam rách gối",
      "giaCu": 499000,
      "giaMoi": 349000,
      "moTaNgan": "Phong cách streetwear năng động",
      "kichThuoc": ["29", "30", "31"],
      "chatLieu":
          "- Vải jean co giãn nhẹ\n- Màu denim bền màu\n- Phối rách tạo điểm nhấn cá tính",
      "baoQuan":
          "- Giặt riêng đồ tối màu\n- Không dùng thuốc tẩy\n- Không sấy nhiệt cao",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Sấy nhẹ",
      "nhietDoUi": "130°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_13-1.png",
        "lib/assets/images/product_detail_13-2.png",
        "lib/assets/images/product_detail_13-3.png",
        "lib/assets/images/product_detail_13-4.png",
        "lib/assets/images/product_detail_13-5.png",
      ],
      "mauSac": ["Nâu", "Đen"],
      "loaiSP": "quần jean",
      "thuongHieu": "Louis Vuiton",
    },
    {
      "tenSP": "Áo thun nam cổ tròn logo nhỏ",
      "giaCu": 299000,
      "giaMoi": 219000,
      "moTaNgan": "Chất liệu co giãn, thoải mái",
      "kichThuoc": ["S", "M", "L"],
      "chatLieu":
          "- Cotton 100% cao cấp\n- Co giãn 4 chiều\n- Thấm hút mồ hôi nhanh",
      "baoQuan":
          "- Giặt máy với chế độ nhẹ\n- Tránh sấy nhiệt cao\n- Phơi nơi thoáng mát",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Phơi nơi thoáng mát",
      "nhietDoUi": "120°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_14-1.png",
        "lib/assets/images/product_detail_14-2.png",
        "lib/assets/images/product_detail_14-3.png",
        "lib/assets/images/product_detail_14-4.png",
        "lib/assets/images/product_detail_14-5.png",
      ],
      "mauSac": ["Nâu", "Xanh Navy"],
      "loaiSP": "Áo thun",
      "thuongHieu": "Givenchy",
    },
    {
      "tenSP": "Áo polo nam dáng regular",
      "giaCu": 379000,
      "giaMoi": 289000,
      "moTaNgan": "Dáng áo basic dễ mặc, dễ phối",
      "kichThuoc": ["M", "L", "XL"],
      "chatLieu":
          "- Vải cotton thoáng khí\n- Bo cổ chắc chắn\n- Không bị bai dão sau nhiều lần giặt",
      "baoQuan":
          "- Không giặt bằng nước nóng\n- Không sấy quá khô\n- Ủi mặt trong ở nhiệt độ vừa",
      "thuocTay": "Không dùng thuốc tẩy",
      "giatKho": "Không giặt khô",
      "sayKho": "Sấy ở nhiệt độ thấp",
      "nhietDoUi": "120°C",
      "hinhAnh": [
        "lib/assets/images/product_detail_15-1.png",
        "lib/assets/images/product_detail_15-2.png",
        "lib/assets/images/product_detail_15-3.png",
        "lib/assets/images/product_detail_15-4.png",
        "lib/assets/images/product_detail_15-5.png",
      ],
      "mauSac": ["Trắng", "Đỏ"],
      "loaiSP": "Áo polo",
      "thuongHieu": "Boss",
    },
  ];

  for (var product in products) {
    final docRef = await firestore.collection('SanPham').add(product);
    await firestore.collection('SanPham').doc(docRef.id).update({
      'maSP': docRef.id,
    });
  }
}
