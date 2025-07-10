import 'package:flutter/material.dart';
import 'package:the4m_app/screens/cart_screen.dart';
import 'package:the4m_app/screens/payment_screen.dart';
import 'package:the4m_app/utils/smoothPushReplacement.dart';
import 'package:the4m_app/widgets/devider.dart';
import 'package:the4m_app/widgets/header.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
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
                                smoothPushReplacementLikePush(
                                  context,
                                  CartScreen(),
                                );
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "THANH TOÁN",
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
                          InputField(initialValue: "Nguyễn Duy Thắng"),
                          SizedBox(height: 16),
                          // Dia chi
                          LabelText("Địa chỉ"),
                          InputField(initialValue: "312/8/9, Quang Trung"),
                          SizedBox(height: 16),
                          // Quan & TP
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText("Phường"),
                                    CustomDropdown(
                                      hint: "Chọn Phường",
                                      items: [
                                        "Gò Vấp",
                                        "Phú Nhuận",
                                        "Tân Bình",
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelText("Thành phố"),
                                    CustomDropdown(
                                      hint: "Chọn TP",
                                      items: ["TP HCM", "Hà Nội", "Đà Nẵng"],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          // So dien thoai
                          LabelText("Số điện thoại"),
                          InputField(initialValue: "0336971705"),
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
            smoothPushReplacementLikePush(context, PaymentScreen());
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

Widget InputField({String? initialValue}) {
  return TextFormField(
    initialValue: initialValue,
    style: TextStyle(fontSize: 14, fontFamily: "NotoSerif_2"),
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
