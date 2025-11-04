import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import 'diemdanh_qr_screen.dart'; // import màn hình QR
import '../widgets/gv_side_menu.dart'; // import Drawer menu
import '../../data/models/monhoc_model.dart'; // import model + dữ liệu
import 'kq_diemdanh_screen.dart';
class DiemDanhScreen extends StatefulWidget {
  const DiemDanhScreen({super.key});

  @override
  State<DiemDanhScreen> createState() => _DiemDanhScreenState();
}

class _DiemDanhScreenState extends State<DiemDanhScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const int _selectedIndex = 2; // Tab thứ 3 - Điểm danh

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: 'GV001', // hoặc lấy từ state nếu cần
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const Center(
              child: Text(
                "ĐIỂM DANH BUỔI HỌC",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PHẦN TIÊU ĐỀ ---
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Môn hiện tại",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          // --- DANH SÁCH MÔN HỌC ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: danhSachMonHoc.length,
                  itemBuilder: (context, index) {
                    final mon = danhSachMonHoc[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${mon.tenMon} - ${mon.tenLop}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Thứ ${mon.thu}, Tiết ${mon.tiet}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          Text(
                            "Phòng: ${mon.phong}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildActionButton(context, mon.trangThai),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GiangVienBottomNav(
        currentIndex: _selectedIndex,
      ),
    );
  }

// ===== NÚT HÀNH ĐỘNG =====
  Widget _buildActionButton(BuildContext context, String trangThai) {
    switch (trangThai) {
      case "dung_gio":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF154B71),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiemDanhQRScreen(),
              ),
            );
          },
          child: const Text("Bắt đầu điểm danh",
              style: TextStyle(fontSize: 13, color: Colors.white)),
        );

      case "qua_gio":
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B7B7B),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            // Chuyển sang màn hình kết quả điểm danh
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KetQuaDiemDanhScreen(),
              ),
            );
          },
          child: const Text("Xem kết quả điểm danh",
              style: TextStyle(fontSize: 13, color: Colors.white)),
        );

      default:
        return const SizedBox();
    }
  }
}
