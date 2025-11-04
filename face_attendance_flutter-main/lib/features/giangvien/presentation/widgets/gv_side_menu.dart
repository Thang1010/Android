import 'package:flutter/material.dart';
import '../../gv_routes.dart';

class GVSideMenu extends StatelessWidget {
  final String giangVienId;
  final VoidCallback onClose;

  const GVSideMenu({
    super.key,
    required this.giangVienId,
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
        // Chỉ đóng Drawer bằng onClose
        onClose();

        // Hàm điều hướng an toàn
        void safeNavigate(String routeName, {Map<String, dynamic>? arguments}) {
          final builder = GvRoutes.routes[routeName];
          if (builder == null) return;

          final route = MaterialPageRoute(
            builder: builder,
            settings: RouteSettings(arguments: arguments),
          );

          if (Navigator.canPop(context)) {
            Navigator.pushReplacement(context, route);
          } else {
            Navigator.push(context, route);
          }
        }

        switch (title) {
          case "Trang chủ":
            safeNavigate(GvRoutes.dashboard, arguments: {"giangVienId": giangVienId});
            break;
          case "Lịch dạy":
            if (ModalRoute.of(context)?.settings.name != GvRoutes.lichday) {
              safeNavigate(GvRoutes.lichday, arguments: {"giangVienId": giangVienId});
            }
            break;
          case "Điểm danh":
            safeNavigate(GvRoutes.diemdanhQR, arguments: {"giangVienId": giangVienId});
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
