import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/chitiet_sv_diemdanh_model.dart';

class BuoiDaDiemDanhScreen extends StatefulWidget {
  final String tenSinhVien;
  final String maSinhVien;
  final String avatarPath; // avatar sinh viên
  final List<DiemDanhBuoiHocChiTiet> diemDanh;

  const BuoiDaDiemDanhScreen({
    super.key,
    required this.tenSinhVien,
    required this.maSinhVien,
    required this.avatarPath,
    required this.diemDanh,
  });

  @override
  State<BuoiDaDiemDanhScreen> createState() => _BuoiDaDiemDanhScreenState();
}

class _BuoiDaDiemDanhScreenState extends State<BuoiDaDiemDanhScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết điểm danh"),
        backgroundColor: const Color(0xFF154B71),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Thông tin sinh viên =====
            Container(
              width: double.infinity,
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(widget.avatarPath),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.tenSinhVien,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("MSV: ${widget.maSinhVien}",
                          style:
                          const TextStyle(fontSize: 14, color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Chi tiết điểm danh",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            // ===== List các buổi điểm danh =====
            widget.diemDanh.isEmpty
                ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Chưa có buổi điểm danh nào"),
                ))
                : Column(
              children: widget.diemDanh.map((buoi) {
                // Hàm xác định màu + icon dựa trên trạng thái
                Color getStatusColor(String status) {
                  switch (status) {
                    case 'present':
                      return Colors.green;
                    case 'absent':
                      return Colors.red;
                    case 'late':
                      return Colors.orange;
                    default:
                      return Colors.grey;
                  }
                }

                IconData getStatusIcon(String status) {
                  switch (status) {
                    case 'present':
                      return Icons.check_circle;
                    case 'absent':
                      return Icons.cancel;
                    case 'late':
                      return Icons.error;
                    default:
                      return Icons.help;
                  }
                }

                String getStatusText(String status) {
                  switch (status) {
                    case 'present':
                      return "Có mặt";
                    case 'absent':
                      return "Vắng";
                    case 'late':
                      return "Đi muộn";
                    default:
                      return "Chưa xác định";
                  }
                }

                final ngayStr = DateFormat('dd/MM/yyyy').format(buoi.ngay);
                final gioStr = DateFormat('HH:mm').format(buoi.gio);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Thông tin buổi học
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${buoi.monHoc} - ${buoi.lop}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(
                                "Ngày: $ngayStr  -  Giờ: $gioStr  -  Phòng: ${buoi.phong}",
                                style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      // Dropdown chọn trạng thái
                      Row(
                        children: [
                          Icon(getStatusIcon(buoi.trangThai),
                              color: getStatusColor(buoi.trangThai)),
                          const SizedBox(width: 6),
                          DropdownButton<String>(
                            value: buoi.trangThai,
                            items: const [
                              DropdownMenuItem(
                                value: 'present',
                                child: Text('Có mặt',
                                    style: TextStyle(color: Colors.green)),
                              ),
                              DropdownMenuItem(
                                value: 'absent',
                                child: Text('Vắng',
                                    style: TextStyle(color: Colors.red)),
                              ),
                              DropdownMenuItem(
                                value: 'late',
                                child: Text('Đi muộn',
                                    style: TextStyle(color: Colors.orange)),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                buoi.trangThai = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
