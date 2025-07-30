import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String? hoTen;
  String? email;
  String? gioiTinh;
  String? ngaySinh;
  String? soDienThoai;
  String? soNha;
  String? phuong;
  String? thanhPho;

  String? get getHoTen => hoTen;
  String? get getEmail => email;

  Future<void> loadUserData(User user) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('KhachHang')
              .doc(user.uid)
              .get();

      hoTen =
          doc.exists ? doc['hoTen'] : (user.displayName ?? "Người dùng mới");
      email = user.email;
      gioiTinh = doc['gioiTinh'] ?? "";
      ngaySinh = doc['ngaySinh'] ?? "";
      soDienThoai = doc['soDienThoai'] ?? "";
      soNha = doc['soNha'] ?? "";
      phuong = doc['phuong'] ?? "";
      thanhPho = doc['thanhPho'] ?? "";
      notifyListeners();
    } catch (e) {
      print("Lỗi loadUserData: $e");
    }
  }

  void setUser(String hoTen, String email) {
    this.hoTen = hoTen;
    this.email = email;
    notifyListeners();
  }

  void clearUser() {
    hoTen = null;
    email = null;
    notifyListeners();
  }
}
