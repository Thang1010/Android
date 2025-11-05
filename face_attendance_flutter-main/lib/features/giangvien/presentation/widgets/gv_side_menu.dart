import 'package:flutter/material.dart';
import '../../gv_routes.dart';
import '../../data/models/buoihoc_model.dart';

class GVSideMenu extends StatelessWidget {
  final String giangVienId;
  final BuoiHoc? buoiHoc; // Buổi học hiện tại cho Điểm danh QR
  final VoidCallback onClose;

  const GVSideMenu({
    super.key,
    required this.giangVienId,
    this.buoiHoc,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nút đóng
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Danh sách menu
            _buildMenuItem(context, Icons.home, "Trang chủ"),
            _buildMenuItem(context, Icons.calendar_today, "Lịch dạy"),
            _buildMenuItem(context, Icons.how_to_reg, "Điểm danh"),
            _buildMenuItem(context, Icons.class_, "Quản lý lớp"),
            _buildMenuItem(context, Icons.bar_chart, "Thống kê"),
            _buildMenuItem(context, Icons.person, "Tôi"),

            const Spacer(),

            // Nút đăng xuất màu đỏ
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("Đăng xuất"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF154B71)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF154B71),
        ),
      ),
      onTap: () {
        // Đóng Drawer
        onClose();

        // Hàm điều hướng an toàn
        void safeNavigate(String routeName, {Map<String, dynamic>? arguments}) {
          GvRoutes.navigate(context, routeName, arguments: arguments);
        }

        switch (title) {
          case "Trang chủ":
            safeNavigate(GvRoutes.dashboard, arguments: {"giangVienId": giangVienId});
            break;
          case "Lịch dạy":
            safeNavigate(GvRoutes.lichday, arguments: {"giangVienId": giangVienId});
            break;
          case "Điểm danh":
            if (buoiHoc != null) {
              // Nếu có buoiHoc hiện tại, truyền vào QR screen
              safeNavigate(GvRoutes.diemdanhQR, arguments: {"buoiHoc": buoiHoc});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        "Hiện không có buổi học đang diễn ra để điểm danh")),
              );
            }
            break;
          case "Quản lý lớp":
            safeNavigate(GvRoutes.quanlylop, arguments: {"giangVienId": giangVienId});
            break;
          case "Thống kê":
            safeNavigate(GvRoutes.thongke, arguments: {"giangVienId": giangVienId});
            break;
          case "Tôi":
            safeNavigate(GvRoutes.profile, arguments: {"giangVienId": giangVienId});
            break;
        }
      },
    );
  }
}
