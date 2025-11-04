import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../widgets/giangvien_bottom_nav.dart';
import 'diemdanh_qr_screen.dart';
import 'lichday_screen.dart';
import 'quanlylop_screen.dart';
import 'thongke_screen.dart';

class GiangVienDashboardScreen extends StatefulWidget {
  const GiangVienDashboardScreen({super.key});

  @override
  State<GiangVienDashboardScreen> createState() =>
      _GiangVienDashboardScreenState();
}

class _GiangVienDashboardScreenState extends State<GiangVienDashboardScreen> {
  final int _selectedIndex = 0;
  late final GiangVien gvHienTai;
  late final List<BuoiHoc> lichDayHomNay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    gvHienTai = currentGV;
    lichDayHomNay = BuoiHoc.lichDayLichDayScreen;

    // Timer cập nhật trạng thái mỗi giây
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Chuyển "07:00-08:30" -> DateTime bắt đầu và kết thúc
  List<DateTime> _parseTimeRange(String thoiGian, DateTime ngay) {
    try {
      final parts = thoiGian.split('-');
      if (parts.length != 2) return [];
      final startParts = parts[0].split(':').map(int.parse).toList();
      final endParts = parts[1].split(':').map(int.parse).toList();
      final start = DateTime(
          ngay.year, ngay.month, ngay.day, startParts[0], startParts[1]);
      final end = DateTime(
          ngay.year, ngay.month, ngay.day, endParts[0], endParts[1]);
      return [start, end];
    } catch (_) {
      return [];
    }
  }

  // Xác định màu trạng thái buổi học
  Color _getStatusColor(BuoiHoc buoi) {
    if (buoi.thoiGian == null || buoi.ngay == null) return Colors.grey;
    final times = _parseTimeRange(buoi.thoiGian!, buoi.ngay!);
    if (times.isEmpty) return Colors.grey;
    final now = DateTime.now();
    final start = times[0];
    final end = times[1];
    if (now.isBefore(start)) return Colors.yellow; // sắp diễn ra
    if (now.isAfter(end)) return Colors.red; // đã kết thúc
    return Colors.green; // đang diễn ra
  }

  // --- APPBAR ---
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF154B71),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/login_illustration.png',
              height: 36,
            ),
          ),
          const Center(
            child: Text(
              "TRANG CHỦ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không có thông báo mới")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- THÔNG TIN GIÁO VIÊN ---
  Widget _buildTeacherInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF154B71),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(currentGV.avatarPath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "GV. ${currentGV.ten}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

// --- LỊCH DẠY HÔM NAY ---
  Widget _buildTodaySchedule() {
    final today = DateTime.now();
    final lichHomNay = lichDayHomNay.where((buoi) {
      if (buoi.ngay == null) return false;
      return buoi.ngay!.year == today.year &&
          buoi.ngay!.month == today.month &&
          buoi.ngay!.day == today.day;
    }).toList();

    const double itemHeight = 77.0;
    const double maxVisibleItems = 3;

    // Định dạng ngày hôm nay
    final formattedDate =
        "${today.day.toString().padLeft(2, '0')}/"
        "${today.month.toString().padLeft(2, '0')}/"
        "${today.year}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF154B71),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + ngày hôm nay
          Row(
            children: [
              const Text(
                "Lịch dạy hôm nay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            height: itemHeight * maxVisibleItems,
            child: lichHomNay.isEmpty
                ? const Center(child: Text("Hôm nay không có lịch dạy"))
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lichHomNay.map((buoi) {
                  Color statusColor;
                  String statusText;
                  if (buoi.thoiGian != null && buoi.ngay != null) {
                    statusColor = _getStatusColor(buoi);
                    if (statusColor == Colors.green) {
                      statusText = "Đang diễn ra";
                    } else if (statusColor == Colors.red) {
                      statusText = "Đã kết thúc";
                    } else {
                      statusText = "Sắp diễn ra";
                      statusColor = Colors.orange;
                    }
                  } else {
                    statusText = "Chưa xác định";
                    statusColor = Colors.grey;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dòng 1: Tên môn - Lớp và trạng thái sát phải
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${buoi.tenMon} - ${buoi.lop}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Dòng 2: Giờ
                        Text(
                          buoi.thoiGian ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        // Dòng 3: Phòng
                        Text(
                          "Phòng ${buoi.phong}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // --- GRID CHỨC NĂNG ---
  Widget _buildFeatureGrid(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        "icon": Icons.qr_code_2,
        "title": "Điểm danh",
        "buttonText": "Bắt đầu điểm danh",
        "screen": const DiemDanhQRScreen(),
      },
      {
        "icon": Icons.calendar_today_outlined,
        "title": "Lịch dạy",
        "buttonText": "Xem lịch dạy",
        "screen": const LichDayScreen(giangVienId: 'GV001'),
      },
      {
        "icon": Icons.people_outline,
        "title": "Quản lý lớp",
        "buttonText": "Chi tiết lớp học",
        "screen": const QuanLyLopScreen(giangVienId: 'GV001'),
      },
      {
        "icon": Icons.bar_chart_outlined,
        "title": "Thống kê",
        "buttonText": "Xem thống kê",
        "screen": const ThongKeScreen(giangVienId: 'GV001'),
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        return _featureCard(
          context,
          item["icon"],
          item["title"],
          item["buttonText"],
          item["screen"],
        );
      },
    );
  }

  Widget _featureCard(BuildContext context, IconData icon, String title,
      String buttonText, Widget screen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF154B71), size: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF154B71),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- GIAO DIỆN CHÍNH ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: _buildHomeAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeacherInfo(),
            const SizedBox(height: 12),
            _buildTodaySchedule(),
            const SizedBox(height: 12),
            _buildFeatureGrid(context),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}
