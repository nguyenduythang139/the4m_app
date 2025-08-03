// lib/screens/momo_webview_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomoWebViewScreen extends StatelessWidget {
  final String payUrl;

  const MomoWebViewScreen({Key? key, required this.payUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                if (request.url.contains("google.com")) {
                  // Thanh toán xong → quay về trang hoàn tất
                  Navigator.pop(context, true);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(payUrl));

    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán MoMo")),
      body: WebViewWidget(controller: controller),
    );
  }
}
