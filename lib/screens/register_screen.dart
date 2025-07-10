import 'package:flutter/material.dart';
import 'login_screen.dart'; // Trang đăng nhập

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các trường nhập liệu
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Biến lưu trạng thái dropdown
  String? _selectedGender;
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedWard;

  // Biến điều khiển hiển thị/ẩn mật khẩu
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không dùng nữa
    _fullNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Hàm tạo ô nhập liệu chuẩn
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontFamily: 'Noto Serif')),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFD9D9D9),
            prefixIcon: Icon(icon, color: Colors.black),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          validator:
              validator ??
              (value) =>
                  value == null || value.isEmpty
                      ? 'Vui lòng nhập $label'
                      : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Hàm tạo dropdown
  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontFamily: 'Noto Serif')),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFD9D9D9),
            prefixIcon: Icon(icon, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Vui lòng chọn $label' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Hàm xử lý khi nhấn nút đăng ký
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Nếu mọi thứ hợp lệ
      print("Registering user...");
      // TODO: Gửi dữ liệu lên server hoặc Firebase
    }
  }

  // Hàm chuyển về màn hình đăng nhập
  void _goBackToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Nút quay lại
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _goBackToLogin,
                    child: Container(
                      width: 41,
                      height: 41,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFE8ECF4), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tiêu đề
                Text(
                  'ĐĂNG KÝ ĐỂ BẮT ĐẦU MUA SẮM!',
                  style: TextStyle(fontSize: 38, fontFamily: 'Noto Serif'),
                ),
                const SizedBox(height: 20),

                // Các trường nhập liệu
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Họ và tên',
                  hint: 'Nhập họ và tên',
                  icon: Icons.person,
                ),
                _buildTextField(
                  controller: _dobController,
                  label: 'Ngày Sinh',
                  hint: 'Nhập ngày sinh',
                  icon: Icons.calendar_today,
                ),
                _buildDropdown(
                  label: 'Giới tính',
                  hint: 'Chọn giới tính',
                  value: _selectedGender,
                  items: ['Nam', 'Nữ', 'Khác'],
                  onChanged: (value) => setState(() => _selectedGender = value),
                  icon: Icons.wc,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Nhập email',
                  icon: Icons.email,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Số điện thoại',
                  hint: 'Nhập số điện thoại',
                  icon: Icons.phone,
                ),
                _buildTextField(
                  controller: _addressController,
                  label: 'Số nhà, tên đường',
                  hint: 'Nhập số nhà, tên đường',
                  icon: Icons.home,
                ),
                _buildDropdown(
                  label: 'Phường/ Xã',
                  hint: 'Chọn phường/ xã',
                  value: _selectedWard,
                  items: ['Phường A', 'Phường B'],
                  onChanged: (value) => setState(() => _selectedWard = value),
                  icon: Icons.location_on,
                ),
                _buildDropdown(
                  label: 'Tỉnh/ Thành Phố',
                  hint: 'Chọn tỉnh/ thành phố',
                  value: _selectedProvince,
                  items: ['Hồ Chí Minh', 'Hà Nội', 'Đà Nẵng'],
                  onChanged:
                      (value) => setState(() => _selectedProvince = value),
                  icon: Icons.location_city,
                ),
                // Mật khẩu
                _buildTextField(
                  controller: _passwordController,
                  label: 'Mật khẩu',
                  hint: 'Nhập mật khẩu',
                  icon: Icons.lock,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    } else if (value.length < 6) {
                      return 'Mật khẩu phải ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),

                // Xác nhận mật khẩu
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Xác nhận mật khẩu',
                  hint: 'Nhập lại mật khẩu',
                  icon: Icons.lock_outline,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible,
                      );
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    } else if (value != _passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Nút đăng ký
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Noto Serif',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Liên kết về đăng nhập
                Center(
                  child: GestureDetector(
                    onTap: _goBackToLogin,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Bạn đã có tài khoản? ',
                            style: TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 15,
                              fontFamily: 'Noto Serif',
                            ),
                          ),
                          TextSpan(
                            text: 'Đăng nhập ngay',
                            style: TextStyle(
                              color: Color(0xFF1E232C),
                              fontSize: 15,
                              fontFamily: 'Noto Serif',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
