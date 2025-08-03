import 'dart:async';
import 'package:flutter/material.dart';
import 'package:the4m_app/screens/complete_order_screen.dart';
import 'package:the4m_app/screens/waiting_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:the4m_app/models/user_provider.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _initDeepLinks();
  // }

  // Future<void> _initDeepLinks() async {
  //   _appLinks = AppLinks();
  //   _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       final resultCode = uri.queryParameters['resultCode'];
  //       final orderId = uri.queryParameters['orderId'] ?? "";
  //       if (resultCode == '0') {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => CompleteOrderScreen(
  //               orderId: orderId,
  //               totalAmount: null, // Không có thông tin từ deep link
  //             ),
  //           ),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Thanh toán thất bại hoặc bị hủy")),
  //         );
  //       }
  //     }
  //   });
  // }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WaitingScreen(),
    );
  }
}
