import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/sinhvien_model.dart';

class DiemDanhQRScreen extends StatefulWidget {
  const DiemDanhQRScreen({super.key});

  @override
  State<DiemDanhQRScreen> createState() => _DiemDanhQRScreenState();
}

class _DiemDanhQRScreenState extends State<DiemDanhQRScreen> {
  bool diemDanhDangMo = false; // trạng thái điểm danh
  bool conGioHoc = true; // còn giờ học
  bool hienThiDanhSach = false; // hiển thị danh sách sinh viên sau khi kết thúc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Điểm danh bằng QR",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin lớp học
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF154B71),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Môn: Lập Trình Web",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 4),
                Text("Lớp: 64KTPM.NB | Phòng: 215 - A1",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text("Thời gian: Tiết 3 - 5 (Thứ Ba)",
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // QR CODE
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: diemDanhDangMo
                            ? const Color(0xFF154B71)
                            : Colors.grey,
                        width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: diemDanhDangMo
                        ? "https://diemdanh.poly.edu.vn/qr/123456"
                        : "",
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  diemDanhDangMo
                      ? "Sinh viên quét mã QR để điểm danh"
                      : "Điểm danh chưa mở hoặc đã kết thúc",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Nút Bắt đầu điểm danh
                if (!diemDanhDangMo && conGioHoc)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF154B71),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        diemDanhDangMo = true;
                        hienThiDanhSach = false; // ẩn danh sách
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("Đã bắt đầu điểm danh, sinh viên quét QR")),
                      );
                    },
                    child: const Text(
                      "Bắt đầu điểm danh",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Hiển thị danh sách sinh viên (cả khi đang điểm danh và sau khi kết thúc)
          if (diemDanhDangMo || hienThiDanhSach) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                diemDanhDangMo
                    ? "Danh sách sinh viên"
                    : "Danh sách sinh viên đã điểm danh",
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: danhSachSinhVien.length,
                  itemBuilder: (context, index) {
                    final sv = danhSachSinhVien[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(sv.avatarOrDefault),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sv.ten,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  Text(sv.ma,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            sv.trangThai,
                            style: TextStyle(
                                fontSize: 13,
                                color: sv.trangThai == "Đã điểm danh"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Nút kết thúc điểm danh, chỉ hiện khi đang điểm danh
            if (diemDanhDangMo)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEB),
                      foregroundColor: const Color(0xFFB71C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFB71C1C)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        diemDanhDangMo = false;
                        hienThiDanhSach = true; // hiển thị danh sách sau khi kết thúc
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã kết thúc điểm danh")),
                      );
                    },
                    child: const Text(
                      "KẾT THÚC ĐIỂM DANH",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFFB71C1C)),
                    ),
                  ),
                ),
              ),
          ],

        ],
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: 2,
        onTap: (index) {
          print("Chuyển tab: $index");
        },
      ),
    );
  }
}
