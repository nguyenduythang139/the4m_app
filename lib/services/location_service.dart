import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const baseUrl = "https://provinces.open-api.vn/api";

  static Future<List<dynamic>> fetchProvinces() async {
    final responce = await http.get(Uri.parse("$baseUrl/p"));
    if (responce.statusCode == 200) {
      return jsonDecode(responce.body);
    } else {
      throw Exception("Lỗi lấy api thành phố!");
    }
  }

  static Future<List<dynamic>> fetchDistricts(int provinceCode) async {
    final responce = await http.get(
      Uri.parse("$baseUrl/p/$provinceCode?depth=2"),
    );
    if (responce.statusCode == 200) {
      final data = jsonDecode(responce.body);
      return data['districts'];
    } else {
      throw Exception("Lỗi lấy api phường!");
    }
  }

  static Future<List<dynamic>> fetchWards(int districtCode) async {
    final responce = await http.get(
      Uri.parse("$baseUrl/d/$districtCode?depth=2"),
    );
    if (responce.statusCode == 200) {
      final data = jsonDecode(responce.body);
      return data['wards'];
    } else {
      throw Exception("Lỗi lấy api phường!");
    }
  }
}
