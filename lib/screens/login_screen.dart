import 'package:flutter/material.dart';
import 'package:the4m_app/screens/forgotpassword_screen';
import 'dart:async';

import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Biến lưu giá trị email và mật khẩu
  String _email = '';
  String _password = '';

  // Biến lưu thông báo lỗi (nếu có)
  String _errorMessage = '';

  // Biến điều khiển hiện/ẩn mật khẩu
  bool _obscurePassword = true;

  // Hàm kiểm tra định dạng Gmail
  bool _isValidGmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Tránh bị che khuất bởi bàn phím
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // 🔴 Hiển thị thông báo lỗi (nếu có)
              if (_errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontFamily: 'Noto Serif',
                    ),
                  ),
                ),

              // 🟠 Logo tròn
              CircleAvatar(
                radius: 64,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage("lib/assets/images/logo.png"),
              ),

              const SizedBox(height: 40),

              // 🟢 Tiêu đề chào mừng
              const Text(
                'CHÀO MỪNG TRỞ LẠI',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Noto Serif',
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 8),

              // 🔵 Phụ đề
              const Text(
                'Chúng tôi rất nhớ bạn!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF555555),
                  fontFamily: 'Noto Serif',
                ),
              ),

              const SizedBox(height: 32),

              // 🟡 Nhãn Email
              _buildLabel('Email'),

              // 🟡 Ô nhập Email
              _buildTextField(
                hint: 'Nhập email',
                icon: Icons.email_outlined,
                obscureText: false,
                onChanged: (value) => _email = value,
              ),

              const SizedBox(height: 16),

              // 🟡 Nhãn Mật khẩu
              _buildLabel('Mật khẩu'),

              // 🔐 Ô nhập mật khẩu
              _buildTextField(
                hint: 'Nhập mật khẩu',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                isPassword: true,
                onChanged: (value) => _password = value,
              ),

              const SizedBox(height: 12),

              // 🔗 Link quên mật khẩu
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Điều hướng tới màn hình quên mật khẩu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: Color(0xFFDD8560),
                      fontFamily: 'Noto Serif',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🔘 Nút Đăng nhập
              _buildMainButton(
                text: 'Đăng nhập',
                color: const Color(0xFFDD8560),
                onPressed: _handleLogin,
              ),

              const SizedBox(height: 32),

              // 🟣 Divider text
              const Text(
                'hoặc tiếp tục với',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Noto Serif',
                ),
              ),

              const SizedBox(height: 16),

              // 🟠 Đăng nhập với Google
              _buildGoogleLoginButton(),

              const SizedBox(height: 24),

              // 🔘 Nút Đăng ký
              _buildMainButton(
                text: 'Đăng ký tài khoản 4M',
                color: Colors.black,
                onPressed: () {
                  // ✅ Chuyển sang RegisterScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 🔎 Hàm xử lý khi bấm nút Đăng nhập
  void _handleLogin() {
    setState(() {
      if (!_isValidGmail(_email.trim())) {
        _errorMessage = 'Vui lòng nhập đúng định dạng email Gmail.';
      } else if (_password.trim().isEmpty) {
        _errorMessage = 'Vui lòng nhập mật khẩu.';
      } else {
        _errorMessage = ''; // ✅ Không có lỗi
        // ✅ Chuyển sang HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }
    });

    // ⏱️ Tự động ẩn lỗi sau 3 giây
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _errorMessage = '';
        });
      }
    });
  }

  // 🏷️ Label Email / Mật khẩu
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontFamily: 'Noto Serif'),
        ),
      ),
    );
  }

  // 🧾 Widget ô nhập liệu
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required bool obscureText,
    required Function(String) onChanged,
    bool isPassword = false,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              obscureText: obscureText,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontFamily: 'Noto Serif',
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(fontSize: 16, fontFamily: 'Noto Serif'),
            ),
          ),

          // 👁 Biểu tượng hiện/ẩn mật khẩu
          if (isPassword)
            IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
        ],
      ),
    );
  }

  // 🔘 Nút chính: Đăng nhập / Đăng ký
  Widget _buildMainButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Noto Serif',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 🔘 Nút đăng nhập Google
  Widget _buildGoogleLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Xử lý đăng nhập Google
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/icons/logo_G.png", width: 24, height: 24),
            const SizedBox(width: 12),
            const Text(
              'Đăng nhập với Google',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Noto Serif',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
