import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({Key? key}) : super(key: key);

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  final _nameController = TextEditingController(text: "Nguyễn Hữu Phước");
  final _genderController = TextEditingController(text: "Nam");
  final _dobController = TextEditingController(text: "16/08/2004");
  final _phoneController = TextEditingController(text: "0398 906 053");
  final _emailController = TextEditingController(text: "huuphuoc@gmail.com");
  final _addressController = TextEditingController(
    text: "387 đường kênh 7, xã Tân Nhựt, huyện Bình Chánh, Tp. Hồ Chí Minh",
  );

  File? _avatarImage;
  File? _backgroundImage;

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
    return Scaffold(
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
                        'lib/assets/images/bg_account.png',
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
