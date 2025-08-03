import 'package:flutter/material.dart';
import 'package:the4m_app/screens/cart_screen.dart';
import 'package:the4m_app/screens/payment_screen.dart';
import 'package:the4m_app/services/location_service.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  List<dynamic> provinces = [];
  List<dynamic> wards = [];

  @override
  void initState() {
    super.initState();
    loadProvinces();
  }

  void loadProvinces() async {
    provinces = await LocationService.fetchProvinces();
    print(provinces);
    setState(() {});
  }

  void loadWards(int provinceCode) async {
    final districts = await LocationService.fetchDistricts(provinceCode);
    List<dynamic> allWards = [];
    for (var district in districts) {
      final districtWards = await LocationService.fetchWards(district['code']);
      allWards.addAll(districtWards);
    }
    setState(() {
      wards = allWards;
    });
  }

  final hoTenController = TextEditingController();
  final diaChiController = TextEditingController();
  final soDienThoaiController = TextEditingController();
  String? selectedProvince;
  String? selectedWard;

  @override
  void dispose() {
    super.dispose();
    hoTenController.dispose();
    diaChiController.dispose();
    soDienThoaiController.dispose();
    selectedProvince = null;
    selectedWard = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                  "THÔNG TIN GIAO HÀNG",
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
                              color: Color(0xffC8C7CC),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ho ten
                          LabelText("Họ và tên"),
                          InputField(
                            controller: hoTenController,
                            hint: "Nhập họ tên người nhận",
                          ),
                          SizedBox(height: 16),
                          // Dia chi
                          LabelText("Địa chỉ"),
                          InputField(
                            controller: diaChiController,
                            hint: "Nhập địa chỉ giao hàng",
                          ),
                          SizedBox(height: 16),
                          // Phuong & TP
                          Row(
                            children: [
                              // Thanh pho
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText("Thành phố"),
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      value: selectedProvince,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black12,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                      hint: Text(
                                        "Chọn thành phố",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      items:
                                          provinces.map((province) {
                                            return DropdownMenuItem<String>(
                                              value:
                                                  province['code'].toString(),
                                              child: Text(
                                                province['name'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "NotoSerif_2",
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedProvince = value;
                                          selectedWard = null;
                                          wards.clear();
                                        });
                                        loadWards(int.parse(value!));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              // Phuong
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText("Phường"),
                                    DropdownButtonFormField<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      value: selectedWard,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black12,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                      hint: Text(
                                        "Chọn phường",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "NotoSerif_2",
                                        ),
                                      ),
                                      items:
                                          wards.map((ward) {
                                            return DropdownMenuItem<String>(
                                              value: ward['code'].toString(),
                                              child: Text(
                                                ward['name'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "NotoSerif_2",
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedWard = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // So dien thoai
                          LabelText("Số điện thoại"),
                          InputField(
                            controller: soDienThoaiController,
                            hint: "Nhập số điện thoại",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 120,
                        child: Image.asset(
                          "lib/assets/images/add_address.png",
                          fit: BoxFit.cover,
                        ),
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
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(),
          ),
          onPressed: () {
            Navigator.pop(context, {
              "hoTen": hoTenController.text,
              "diaChi": diaChiController.text,
              "soDienThoai": soDienThoaiController.text,
              "thanhPho":
                  provinces.firstWhere(
                    (p) => p['code'].toString() == selectedProvince,
                  )['name'],
              "phuong":
                  wards.firstWhere(
                    (w) => w['code'].toString() == selectedWard,
                  )['name'],
            });
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text(
            "XÁC NHẬN",
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

Widget LabelText(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.orange,
        fontSize: 13,
        fontFamily: "NotoSerif_2",
      ),
    ),
  );
}

Widget InputField({TextEditingController? controller, String? hint}) {
  return TextFormField(
    controller: controller,
    style: TextStyle(fontSize: 14, fontFamily: "NotoSerif_2"),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, fontFamily: "NotoSerif_2"),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black26),
      ),
    ),
  );
}

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;

  const CustomDropdown({required this.hint, required this.items, super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      value: selected,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
      hint: Text(
        widget.hint,
        style: TextStyle(fontSize: 14, fontFamily: "NotoSerif_2"),
      ),
      items:
          widget.items.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 14, fontFamily: "NotoSerif_2"),
              ),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
