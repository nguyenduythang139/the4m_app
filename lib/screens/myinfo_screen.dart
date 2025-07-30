import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:the4m_app/models/user_provider.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({Key? key}) : super(key: key);

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  File? _avatarImage;
  File? _backgroundImage;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserProvider>(context, listen: false).loadUserData(user);
      });
    }
  }

  Future<void> _pickAvatarImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarImage = File(picked.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _backgroundImage = File(picked.path);
      });
    }
  }

  void _saveInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đã lưu thông tin thành công")),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    _nameController.text = userProvider.hoTen ?? '';
    _genderController.text = userProvider.gioiTinh ?? '';
    _dobController.text = userProvider.ngaySinh ?? '';
    _phoneController.text = userProvider.soDienThoai ?? '';
    _emailController.text = userProvider.email ?? '';
    _addressController.text =
        "${userProvider.soNha ?? ''}, ${userProvider.phuong ?? ''}, ${userProvider.thanhPho ?? ''}";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            GestureDetector(
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
                        'lib/assets/images/background_1.png',
                        width: MediaQuery.of(context).size.width,
                        height: 235,
                        fit: BoxFit.cover,
                      ),
            ),
            Column(
              children: [
                const SizedBox(height: 130),
                Center(
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
                                  : const AssetImage(
                                        'lib/assets/images/avatar.png',
                                      )
                                      as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickAvatarImage,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildEditableField("Họ và Tên", _nameController),
                      _buildEditableField("Giới tính", _genderController),
                      _buildEditableField("Ngày sinh", _dobController),
                      _buildEditableField("Số điện thoại", _phoneController),
                      _buildEditableField("Email", _emailController),
                      _buildEditableField("Địa chỉ", _addressController),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveInfo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDD8560),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Lưu",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Noto Serif',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Đang ở tab "Tài khoản"
        onTap: (index) {},
      ),
    );
  }
}
