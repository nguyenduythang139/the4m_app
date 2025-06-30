import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the4m_app/screens/login_screen.dart'; // ✅ Import LoginScreen

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  // ✅ Hàm chuyển về màn hình đăng nhập
  void _goBackToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // ✅ Nút quay lại
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => _goBackToLogin(context),
                  child: Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE8ECF4)),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Ảnh minh hoạ
              Center(
                child: SizedBox(
                  width: 128,
                  height: 128,
                  child: Image.asset('lib/assets/images/forgotpass.png'),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'BẠN QUÊN MẬT KHẨU?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Noto Serif',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              const Text(
                'Đừng lo lắng! Vui lòng nhập địa chỉ email được liên kết với tài khoản của bạn.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Noto Serif',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Noto Serif',
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Ô nhập email
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  hintText: 'Nhập email',
                  prefixIcon: const Icon(Icons.email),
                  hintStyle: const TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Nút gửi mã xác nhận
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: xử lý gửi mã xác nhận
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD8560),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Gửi mã xác nhận',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Noto Serif',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Dòng "Bạn nhớ mật khẩu? Đăng nhập ngay"
              RichText(
                text: TextSpan(
                  text: 'Bạn nhớ mật khẩu? ',
                  style: const TextStyle(
                    color: Color(0xFF1E232C),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Noto Serif',
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Đăng nhập ngay',
                      style: const TextStyle(
                        color: Color(0xFF1E232C),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Noto Serif',
                        height: 1.4,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _goBackToLogin(context),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
