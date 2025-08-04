import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import '../screens/notification_screen.dart';
import '../models/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/search_screen.dart';
import '../screens/myinfo_screen.dart';
import '../screens/order_history_screen.dart';
import '../utils/smoothPushReplacement.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/drawer.dart';

class Account_Screen extends StatefulWidget {
  const Account_Screen({Key? key}) : super(key: key);

  @override
  State<Account_Screen> createState() => _Account_ScreenState();
}

class _Account_ScreenState extends State<Account_Screen>
    with WidgetsBindingObserver {
  File? _avatarImage;
  File? _backgroundImage;
  String selectedPage = "Tài khoản";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadImagesFromStorage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); //để cleanup
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadImagesFromStorage(); // reload ảnh khi quay lại
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

  Future<void> _loadImagesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('avatar_path');
    final backgroundPath = prefs.getString('background_path');
    setState(() {
      if (avatarPath != null) _avatarImage = File(avatarPath);
      if (backgroundPath != null) _backgroundImage = File(backgroundPath);
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'avatar_$timestamp.jpg';
      final saved = await resizeAndSaveImage(File(pickedFile.path), fileName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', saved.path);

      setState(() {
        _avatarImage = File(saved.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'background_$timestamp.jpg';
      final saved = await resizeAndSaveImage(File(pickedFile.path), fileName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('background_path', saved.path);

      setState(() {
        _backgroundImage = File(saved.path);
      });
    }
  }

  void _handleTabChange(int index) {
    if (index == 4) return;
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = SearchScreen();
        break;
      default:
        return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
        selectedPage: selectedPage,
        onSelect: (String newPage) {
          setState(() => selectedPage = newPage);
          Navigator.pop(context);
        },
      ),
      body: Stack(
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
          Positioned(
            top: 320,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD9D9D9)),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProvider.hoTen ?? "Đang tải ...",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'NotoSerif_2',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userProvider.email ?? "Đang tải ...",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.settings, size: 30, color: Colors.grey),
                ],
              ),
            ),
          ),
          Positioned(
            top: 435,
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
                    offset: Offset(0, 2),
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
        currentIndex: 4,
        onTap: _handleTabChange,
      ),
    );
  }

  Widget _buildOptionItem(String title, IconData icon) {
    return InkWell(
      onTap: () async {
        if (title == 'Thông tin cá nhân') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyInfoScreen()),
          );
        } else if (title == 'Lịch sử mua hàng') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        } else if (title == 'Thông báo') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
        } else if (title == 'Đăng xuất') {
          try {
            await FirebaseAuth.instance.signOut();
            final GoogleSignIn googleSignIn = GoogleSignIn();
            if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();
            if (context.mounted) {
              smoothPushReplacementLikePush(context, LoginScreen());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đăng xuất thành công!")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lỗi đăng xuất, vui lòng thử lại!")),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 25, color: Colors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
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
