import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class MoMoPaymentService {
  final String partnerCode = "MOMO";
  final String accessKey = "F8BBA842ECF85";
  final String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
  final String redirectUrl = "momo://payment-success"; // deep link về app
  final String ipnUrl = "https://webhook.site/xxxx"; // có thể bỏ trống khi demo

  Future<void> createPayment(int amount) async {
    final requestId = "$partnerCode${DateTime.now().millisecondsSinceEpoch}";
    final orderId = requestId;
    const orderInfo = "Thanh toán đơn hàng Flutter";
    const requestType = "captureWallet";
    const extraData = "";

    final rawSignature =
        "accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType";

    final signature =
        Hmac(
          sha256,
          utf8.encode(secretKey),
        ).convert(utf8.encode(rawSignature)).toString();

    final body = {
      "partnerCode": partnerCode,
      "accessKey": accessKey,
      "requestId": requestId,
      "amount": amount.toString(),
      "orderId": orderId,
      "orderInfo": orderInfo,
      "redirectUrl": redirectUrl,
      "ipnUrl": ipnUrl,
      "extraData": extraData,
      "requestType": requestType,
      "signature": signature,
      "lang": "vi",
    };

    final response = await http.post(
      Uri.https("test-payment.momo.vn", "/v2/gateway/api/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final result = jsonDecode(response.body);
    if (result["payUrl"] != null) {
      final payUrl = result["payUrl"];
      await launchUrl(Uri.parse(payUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Tạo đơn hàng thất bại: ${result['message']}");
    }
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';

// class MoMoPaymentService {
//   final String partnerCode = "MOMO";
//   final String accessKey = "F8BBA842ECF85";
//   final String secretKey = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
//   final String redirectUrl = "https://google.com";
//   final String ipnUrl = "https://momo.fake/ipn";

//   Future<String?> createPayment(int amount) async {
//     final requestId = "$partnerCode${DateTime.now().millisecondsSinceEpoch}";
//     final orderId = requestId;
//     const orderInfo = "Thanh toán đơn hàng Flutter";
//     const requestType = "captureWallet";
//     const extraData = "";

//     final rawSignature =
//         "accessKey=$accessKey&amount=$amount&extraData=$extraData&ipnUrl=$ipnUrl&orderId=$orderId&orderInfo=$orderInfo&partnerCode=$partnerCode&redirectUrl=$redirectUrl&requestId=$requestId&requestType=$requestType";

//     final signature =
//         Hmac(
//           sha256,
//           utf8.encode(secretKey),
//         ).convert(utf8.encode(rawSignature)).toString();

//     final body = {
//       "partnerCode": partnerCode,
//       "accessKey": accessKey,
//       "requestId": requestId,
//       "amount": amount.toString(),
//       "orderId": orderId,
//       "orderInfo": orderInfo,
//       "redirectUrl": redirectUrl,
//       "ipnUrl": ipnUrl,
//       "extraData": extraData,
//       "requestType": requestType,
//       "signature": signature,
//       "lang": "vi",
//     };

//     final response = await http.post(
//       Uri.https("test-payment.momo.vn", "/v2/gateway/api/create"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );

//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body);
//       return result["payUrl"];
//     }
//     return null;
//   }
// }
