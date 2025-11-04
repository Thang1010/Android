import 'package:flutter/material.dart';
import 'presentation/screens/giangvien_dashboard_screen.dart';
import 'presentation/screens/diemdanh_screen.dart';
import 'presentation/screens/diemdanh_qr_screen.dart';
import 'presentation/screens/lichday_screen.dart';
import 'presentation/screens/quanlylop_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/thongke_screen.dart';

class GvRoutes {
  static const String dashboard = '/giangvien/dashboard';
  static const String diemdanh = '/giangvien/diemdanh';
  static const String diemdanhQR = '/giangvien/diemdanh_qr';
  static const String lichday = '/giangvien/lichday';
  static const String quanlylop = '/giangvien/quanlylop';
  static const String profile = '/giangvien/profile';
  static const String thongke = '/giangvien/thongke';

  static Map<String, WidgetBuilder> routes = {
    dashboard: (_) => const GiangVienDashboardScreen(),
    diemdanh: (_) => const DiemDanhScreen(),
    diemdanhQR: (_) => const DiemDanhQRScreen(),
    lichday: (_) => const LichDayScreen(giangVienId: 'GV001'),
    quanlylop: (_) => const QuanLyLopScreen(giangVienId: 'GV001'),
    profile: (_) => const ProfileScreen(giangVienId: 'GV001'),
    thongke: (_) => const ThongKeScreen(giangVienId: 'GV001'),
  };

  // --------------------------- HÀM NAVIGATE ---------------------------
  static void navigate(BuildContext context, String route, {Map<String, dynamic>? arguments}) {
    Navigator.pop(context); // đóng Drawer trước khi điều hướng

    if (routes.containsKey(route)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            final builder = routes[route]!;
            return builder(context);
          },
          settings: RouteSettings(arguments: arguments),
        ),
      );
    } else {
      // Nếu route không tồn tại, fallback về dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GiangVienDashboardScreen()),
      );
    }
  }
}
