import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Hình nền xoay (hiện tại chưa xoay vì angle = 0)
          Positioned.fill(
            child: Transform.rotate(
              angle: 0,
              child: Image.asset(
                'lib/assets/images/bg_waitingScreen.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Thanh trắng hình bo bên trái, chứa lời chào
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            child: Container(
              width: screenWidth * 0.75,
              height: 61,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          // Text "Xin chào!"
          Positioned(
            top: screenHeight * 0.105,
            left: screenWidth * 0.33,
            child: Text(
              'Xin chào!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 44,
                fontFamily: 'Tenor Sans',
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
            ),
          ),

          // Avatar logo tròn
          Positioned(
            top: screenHeight * 0.06,
            left: 16,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 7, color: Colors.white),
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Text "Hãy trải nghiệm"
          Positioned(
            top: screenHeight * 0.18,
            left: screenWidth * 0.35,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hãy trải nghiệm',
                style: TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 20,
                  fontFamily: 'Tenor Sans',
                ),
              ),
            ),
          ),

          // Text "mua sắm cùng chúng tôi nào!"
          Positioned(
            top: screenHeight * 0.23,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'mua sắm cùng chúng tôi nào!',
                style: TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 20,
                  fontFamily: 'Tenor Sans',
                ),
              ),
            ),
          ),

          // Nút Đăng nhập
          Positioned(
            bottom: screenHeight * 0.11,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Khi nhấn sẽ chuyển sang màn hình Login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 55),
              ),
              child: Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Nút Đăng ký
          Positioned(
            bottom: screenHeight * 0.04,
            left: 16,
            right: 16,
            child: OutlinedButton(
              onPressed: () {
                // Khi nhấn sẽ chuyển sang màn hình Register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 55),
              ),
              child: Text(
                'Đăng ký',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto Slab',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
