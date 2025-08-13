# the4m_app

Giới thiệu:
- The 4M là ứng dụng bán quần áo nam hiện đại, giúp khách hàng dễ dàng tìm kiếm, mua sắm và đặt hàng trực tuyến. Ứng dụng được phát triển bằng Flutter và Firebase Firestore, giao diện trực quan và dễ sử dụng.
- Ứng dụng phù hợp với các shop thời trang nam muốn mở rộng kinh doanh online, quản lý sản phẩm và đơn hàng hiệu quả.
- Tính năng chính:
  + Đăng ký / Đăng nhập tài khoản (hỗ trợ Google Sign-In): Người dùng có thể tạo tài khoản mới hoặc đăng nhập bằng tài khoản đã có. Hệ thống hỗ trợ cả đăng nhập truyền thống (email & mật khẩu) và đăng nhập nhanh qua Google, giúp tối ưu trải nghiệm người dùng và tiết kiệm thời gian.
  + Duyệt và tìm kiếm sản phẩm: Người dùng có thể dễ dàng tìm kiếm các sản phẩm thời trang nam như: Áo sơ mi, áo thun, quần jeans, quần tây, áo khoác, phụ kiện (Nón),...thông qua thanh tìm kiếm hoặc theo danh mục. Hệ thống hỗ trợ lọc sản phẩm theo loại, giá cả từ thấp đến cao hoặc từ cao đến thấp và hiển thị sản phẩm theo ngày nhập hàng (Mới nhất – Cũ nhất).
  + Xem chi tiết sản phẩm: Mỗi sản phẩm đều có phần mô tả chi tiết bao gồm hình ảnh, tên sản phẩm – thương hiệu, giá thành, màu sắc, kích cỡ, chất liệu, bảo quản, dịch vụ, đánh giá sản phẩm.
  + Thêm sản phẩm vào mục yêu thích: Người dùng có thể đánh dấu những sản phẩm yêu thích để dễ dàng xem lại hoặc mua sau. Tính năng này sẽ giúp khách hàng không bỏ lỡ những sản phẩm phù hợp với bản thân mình.
  +	Thêm vào giỏ hàng: Người dùng có thể thêm các sản phẩm mà mình cảm thấy ưng ý vào giỏ hàng, điều chỉnh số lượng, thêm hoặc xóa các sản phẩm mình cho rằng không phù hợp lắm ra hoặc vào giỏ hàng. Sau đó thực hiện quá trình đặt hàng.
  +	Đặt hàng và thanh toán: Người dùng có thể đặt mua các sản phẩm mà mình yêu thích thông qua hệ thống khi nhập địa chỉ giao hàng, chọn phương thức vận chuyển và phương thức thanh toán. Hệ thống hỗ trợ phương thức vận chuyển như: Giao tiết kiệm (Miễn phí), giao tiêu chuẩn (20.000VND) và chuyển phát nhanh (40.000VND). Thanh toán sẽ gồm hai phương thức chính là: Thanh toán tiền mặt và thanh toán bằng MoMo.
  + Áp dụng phiếu giảm giá: Người dùng có thể chọn phiếu giảm giá để được khấu trừ trực tiếp một phần chi phí đơn hàng. Hệ thống sẽ kiểm tra tính hợp lệ của phiếu giảm giá (Thời hạn sử dụng) và hiển thị mức giảm tương ứng. Chức năng này sẽ thu hút khách hàng mua sắm nhiều hơn, tạo động lực quay lại ứng dụng và mức độ hài lòng của người dùng.
  +	Xem lịch sử mua hàng: Hệ thống lưu lại danh sách các đơn hàng trước đó, bao gồm thông tin sản phẩm, số lượng, giá, ngày đặt hàng. Đồng thời, người dùng có thể xem chi tiết đơn hàng gồm: mã đơn hàng, ngày đặt hàng, tên người nhận, số điện thoại, địa chỉ giao hàng, phương thức thanh toán, tổng tiền sản phẩm, phí vận chuyển, tổng cộng, trạng thái đơn hàng. Điều này giúp người dùng dễ dàng quản lý chi tiêu và mua lại sản phẩm từng dùng.
  +	Đánh giá sản phẩm: Sau khi nhận hàng và trải nghiệm, người dùng có thể đánh giá chất lượng sản phẩm và dịch vụ, góp phần cải thiện chất lượng sản phẩm hoặc ứng dụng.
  +	Quản lý thông tin cá nhân: Người dùng có thể cập nhật các thông tin cá nhân như: Họ và tên, giới tính, ngày sinh, số điện thoại, địa chỉ, ảnh đại diện hoặc nền.
 -Công nghệ sử dụng:
  + Ngôn ngữ: Dart (Flutter)
  + Backend & Database: Firebase Firestore & API thanh toán
  + Triển khai: Android
- Kết quả đạt được: Nhóm đã phát triển thành công The 4M – ứng dụng thương mại điện tử thời trang nam với các chức năng: đăng ký/đăng nhập (Google SSO), tìm kiếm, giỏ hàng, đặt hàng, quản lý đơn hàng và chỉnh sửa thông tin cá nhân. Ứng dụng xây dựng bằng Flutter kết nối Firebase, đảm bảo hiệu năng và trải nghiệm mượt mà. Nhóm cũng hoàn thiện thiết kế giao diện trên Figma, qua đó nâng cao kỹ năng UI/UX, lập trình đa nền tảng và xử lý dữ liệu thời gian thực.
- Hiện tại chưa có bản chạy ổn định.
- Nhóm phát triển:
  + UI/UX Design: Nguyễn Duy Thắng - Lữ Trung Tín - Nguyễn Hữu Phước - Lê Đăng Khoa
  + Frontend: Nguyễn Duy Thắng - Lữ Trung Tín - Nguyễn Hữu Phước - Lê Đăng Khoa
  + Backend: Nguyễn Duy Thắng - Lữ Trung Tín - Nguyễn Hữu Phước
- Cách cài đặt và chạy dự án:
  + Clone dự án: git clone https://github.com/nguyenduythang139/the4m_app.git
  + Cài đặt dependencies: flutter pub get


