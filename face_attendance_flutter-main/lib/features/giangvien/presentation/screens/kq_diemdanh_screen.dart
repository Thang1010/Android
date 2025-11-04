import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/sinhvien_model.dart'; // model + dữ liệu
import 'diemdanh_screen.dart'; // trang trước

class KetQuaDiemDanhScreen extends StatefulWidget {
  final int currentTab; // tab hiện tại từ trang trước

  const KetQuaDiemDanhScreen({super.key, this.currentTab = 2});

  @override
  State<KetQuaDiemDanhScreen> createState() => _KetQuaDiemDanhScreenState();
}

class _KetQuaDiemDanhScreenState extends State<KetQuaDiemDanhScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // quay lại trang trước
          },
        ),
        title: const Text(
          "Điểm danh buổi học",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // THÔNG TIN LỚP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Môn học: Lập trình Android",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 10),
                  Text("Lớp: 64KTPM.NB",
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                  SizedBox(height: 10),
                  Text("Thời gian: Thứ năm, 7:00 - 9:45",
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                  SizedBox(height: 10),
                  Text("Phòng học: 325 - A2",
                      style: TextStyle(color: Colors.black87, fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TRẠNG THÁI ĐIỂM DANH
            const Text(
              "Trạng thái điểm danh",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            // DANH SÁCH SINH VIÊN
            Expanded(
              child: ListView.builder(
                itemCount: danhSachSinhVien.length,
                itemBuilder: (context, index) {
                  final sv = danhSachSinhVien[index];
                  return _buildStudentCard(
                    sv,
                        (newStatus) {
                      setState(() {
                        sv.trangThai = newStatus;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: widget.currentTab, // giữ tab Điểm danh
        onTap: (index) {
          // khi chọn tab khác, bạn có thể chuyển màn hình tương ứng
          print("Chuyển sang tab $index");
        },
      ),
    );
  }

  // WIDGET: THẺ SINH VIÊN
  Widget _buildStudentCard(SinhVien sv, Function(String) onStatusChanged) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (sv.trangThai) {
      case "present":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = "Có mặt";
        break;
      case "absent":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = "Vắng";
        break;
      case "late":
        statusColor = Colors.orange;
        statusIcon = Icons.error;
        statusText = "Đi muộn";
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = "Không rõ";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              sv.avatarOrDefault,
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin sinh viên
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sv.ten,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(sv.lop,
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 13)),
                Text("Mã SV: ${sv.ma}",
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),

          // Trạng thái + dropdown
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 4),
              Text(
                statusText,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                onSelected: (value) {
                  onStatusChanged(value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "present", child: Text("Có mặt")),
                  PopupMenuItem(value: "absent", child: Text("Vắng")),
                  PopupMenuItem(value: "late", child: Text("Đi muộn")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
