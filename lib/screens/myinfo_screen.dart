//================= MYINFOSCREEN =================
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:the4m_app/widgets/bottom_navigation.dart';
import 'package:the4m_app/models/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({Key? key}) : super(key: key);

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen>
    with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    _loadUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserInfo(); // load lại ảnh và dữ liệu khi quay lại
    }
  }

  Future<File> resizeAndSaveImage(File file, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    final resized = img.copyResize(image!, width: 600);
    final newPath = p.join(dir.path, fileName);
    final newFile = File(newPath)..writeAsBytesSync(img.encodeJpg(resized));
    return newFile;
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData(user);
      final prefs = await SharedPreferences.getInstance();
      final avatarPath = prefs.getString('avatar_path');
      final backgroundPath = prefs.getString('background_path');

      setState(() {
        _nameController.text = userProvider.hoTen ?? '';
        _genderController.text = userProvider.gioiTinh ?? '';
        _dobController.text = userProvider.ngaySinh ?? '';
        _phoneController.text = userProvider.soDienThoai ?? '';
        _emailController.text = userProvider.email ?? '';
        _addressController.text =
            "${userProvider.soNha ?? ''}, ${userProvider.phuong ?? ''}, ${userProvider.thanhPho ?? ''}";
        if (avatarPath != null) _avatarImage = File(avatarPath);
        if (backgroundPath != null) _backgroundImage = File(backgroundPath);
      });
    }
  }

  Future<void> _pickAvatarImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'avatar_$timestamp.jpg';
      final saved = await resizeAndSaveImage(File(picked.path), fileName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', saved.path);

      setState(() {
        _avatarImage = File(saved.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'background_$timestamp.jpg';
      final saved = await resizeAndSaveImage(File(picked.path), fileName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('background_path', saved.path);

      setState(() {
        _backgroundImage = File(saved.path);
      });
    }
  }

  Future<void> _saveInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final addressParts = _addressController.text.split(',');
      final soNha = addressParts.length > 0 ? addressParts[0].trim() : '';
      final phuong = addressParts.length > 1 ? addressParts[1].trim() : '';
      final thanhPho = addressParts.length > 2 ? addressParts[2].trim() : '';

      await FirebaseFirestore.instance
          .collection('KhachHang')
          .doc(currentUser.uid)
          .update({
            'hoTen': _nameController.text,
            'gioiTinh': _genderController.text,
            'ngaySinh': _dobController.text,
            'soDienThoai': _phoneController.text,
            'soNha': soNha,
            'phuong': phuong,
            'thanhPho': thanhPho,
          });

      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).loadUserData(currentUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu thông tin thành công")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi lưu: $e")));
    }
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
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Giới tính",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value:
                _genderController.text.isEmpty ? null : _genderController.text,
            items:
                ['Nam', 'Nữ', 'Khác']
                    .map(
                      (gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)),
                    )
                    .toList(),
            onChanged:
                (value) => setState(() => _genderController.text = value ?? ''),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDobField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ngày sinh",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _dobController,
            readOnly: true,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(
                  () =>
                      _dobController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(picked),
                );
              }
            },
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Noto Serif',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              isDense: true,
              hintText: 'DD/MM/YYYY',
              suffixIcon: Icon(Icons.calendar_today, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      _buildGenderField(),
                      _buildDobField(),
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
      bottomNavigationBar: BottomNavBar(currentIndex: 4, onTap: (index) {}),
    );
  }
}
