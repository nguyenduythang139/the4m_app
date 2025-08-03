import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class VnPayPaymentPage extends StatefulWidget {
  final int amount;
  const VnPayPaymentPage({super.key, required this.amount});

  @override
  State<VnPayPaymentPage> createState() => _VnPayPaymentPageState();
}

class _VnPayPaymentPageState extends State<VnPayPaymentPage> {
  String? paymentUrl;
  late final WebViewController controller;

  // Có thể thay đổi URL này để gọi server từ xa
  static const String serverUrl = 'http://192.168.102.6:8080'; // Thay bằng IP thực của máy bạn
  // Hoặc nếu deploy lên cloud: 'https://your-server.herokuapp.com'

  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                if (request.url.contains('callback')) {
                  final uri = Uri.parse(request.url);
                  final code = uri.queryParameters['vnp_ResponseCode'];
                  Navigator.pop(context, {'code': code});
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );
    createPaymentUrl();
  }

  Future<void> createPaymentUrl() async {
    try {
      final res = await http.get(
        Uri.parse(
          "$serverUrl/create_payment?amount=${widget.amount}",
        ),
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          paymentUrl = data['paymentUrl'];
          if (paymentUrl != null) {
            controller.loadRequest(Uri.parse(paymentUrl!));
          }
        });
      } else {
        print('Error: ${res.statusCode} - ${res.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối server: ${res.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán VNPay")),
      body:
          paymentUrl == null
              ? const Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controller),
    );
  }
}
