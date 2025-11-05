import 'package:flutter/material.dart';
import 'presentation/screens/giangvien_dashboard_screen.dart';
import 'presentation/screens/diemdanh_screen.dart';
import 'presentation/screens/diemdanh_qr_screen.dart';
import 'presentation/screens/lichday_screen.dart';
import 'presentation/screens/quanlylop_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/thongke_screen.dart';
import 'data/models/buoihoc_model.dart';

class GvRoutes {
  static const String dashboard = '/giangvien/dashboard';
  static const String diemdanh = '/giangvien/diemdanh';
  static const String diemdanhQR = '/giangvien/diemdanh_qr';
  static const String lichday = '/giangvien/lichday';
  static const String quanlylop = '/giangvien/quanlylop';
  static const String profile = '/giangvien/profile';
  static const String thongke = '/giangvien/thongke';

  // Các route tĩnh không cần tham số
  static Map<String, WidgetBuilder> staticRoutes = {
    dashboard: (_) => const GiangVienDashboardScreen(),
    diemdanh: (_) => const DiemDanhScreen(),
    lichday: (_) => const LichDayScreen(giangVienId: 'GV001'),
    quanlylop: (_) => const QuanLyLopScreen(giangVienId: 'GV001'),
    profile: (_) => const ProfileScreen(giangVienId: 'GV001'),
    thongke: (_) => const ThongKeScreen(giangVienId: 'GV001'),
  };

  // --------------------------- HÀM NAVIGATE ---------------------------
  /// [arguments] có thể truyền tham số động, ví dụ buoiHoc cho DiemDanhQRScreen
  static void navigate(BuildContext context, String route,
      {Map<String, dynamic>? arguments}) {
    Navigator.pop(context); // đóng Drawer trước khi điều hướng

    if (route == diemdanhQR) {
      // Buộc phải có buoiHoc
      final BuoiHoc? buoiHoc = arguments?['buoiHoc'];
      if (buoiHoc != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiemDanhQRScreen(buoiHoc: buoiHoc),
          ),
        );
      } else {
        // Nếu thiếu buoiHoc, fallback về dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không tìm thấy buổi học để điểm danh!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GiangVienDashboardScreen()),
        );
      }
    } else if (staticRoutes.containsKey(route)) {
      final builder = staticRoutes[route]!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: builder),
      );
    } else {
      // fallback nếu route không tồn tại
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GiangVienDashboardScreen()),
      );
    }
  }
}
