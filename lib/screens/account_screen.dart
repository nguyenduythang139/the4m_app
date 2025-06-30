import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the4m_app/screens/home_screen.dart';
import 'package:the4m_app/screens/login_screen.dart';
import 'package:the4m_app/screens/myinfo_screen.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';

class Account_Screen extends StatefulWidget {
  const Account_Screen({Key? key}) : super(key: key);

  @override
  State<Account_Screen> createState() => _Account_ScreenState();
}

class _Account_ScreenState extends State<Account_Screen> {
  File? _avatarImage;
  File? _backgroundImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _backgroundImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Cover image
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: _pickBackgroundImage,
              child:
                  _backgroundImage != null
                      ? Image.file(
                        _backgroundImage!,
                        width: MediaQuery.of(context).size.width,
                        height: 235,
                        fit: BoxFit.cover,
                      )
                      : Image.asset(
                        'lib/assets/images/bg_account.png',
                        width: MediaQuery.of(context).size.width,
                        height: 235,
                        fit: BoxFit.cover,
                      ),
            ),
          ),

          // Avatar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 130),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 72,
                      backgroundImage:
                          _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : const AssetImage('lib/assets/images/avatar.png')
                                  as ImageProvider,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFD9D9D9),
                        radius: 20,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User info
          Positioned(
            top: 300,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9)),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phước Nguyễn',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Noto Serif',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'huuphuoc@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.settings, size: 30, color: Colors.grey),
                ],
              ),
            ),
          ),

          // Options
          Positioned(
            top: 415,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9D9D9)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFC1C1C1),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOptionItem('Thông tin cá nhân', Icons.person),
                  _buildDivider(),
                  _buildOptionItem('Lịch sử mua hàng', Icons.history),
                  _buildDivider(),
                  _buildOptionItem('Thông báo', Icons.notifications),
                  _buildDivider(),
                  _buildOptionItem('Đăng xuất', Icons.logout),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // tab "Tài khoản"
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
            case 4:
              // Đã ở màn hiện tại
              break;
          }
        },
      ),
    );
  }

  Widget _buildOptionItem(String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'Thông tin cá nhân') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyInfoScreen()),
          );
        } else if (title == 'Đăng xuất') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Noto Serif',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: const Color(0xFFD5D5D5),
    );
  }
}
