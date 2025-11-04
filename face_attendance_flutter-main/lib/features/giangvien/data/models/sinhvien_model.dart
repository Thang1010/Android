import 'chitiet_sv_diemdanh_model.dart';

class SinhVien {
  final String ma;
  final String ten;
  final String lop;
  String trangThai;
  String? avatar;
  int soBuoiDiemDanh; // số buổi đã điểm danh trong học kỳ
  List<DiemDanhBuoiHocChiTiet> diemDanhChiTiet; // danh sách chi tiết các buổi điểm danh

  SinhVien({
    required this.ma,
    required this.ten,
    required this.lop,
    this.trangThai = "unknown",
    this.avatar,
    this.soBuoiDiemDanh = 0,
    List<DiemDanhBuoiHocChiTiet>? diemDanhChiTiet,
  }) : diemDanhChiTiet = diemDanhChiTiet ?? [];

  String get avatarOrDefault => avatar ?? 'assets/images/toandeptrai.jpg';
}

// =================== DỮ LIỆU MẪU ===================
final List<SinhVien> danhSachSinhVien = [
  SinhVien(
    ten: "Nguyễn Văn A",
    ma: "SV001",
    lop: "64KTPM.NB",
    trangThai: "present",
    soBuoiDiemDanh: 18,
    diemDanhChiTiet: diemDanhChiTietMau, // dùng danh sách mẫu
  ),
  SinhVien(
    ten: "Trần Thị B",
    ma: "SV002",
    lop: "64CNTT",
    trangThai: "absent",
    soBuoiDiemDanh: 15,
  ),
  SinhVien(
    ten: "Lê Văn C",
    ma: "SV003",
    lop: "64CNTT",
    trangThai: "late",
    soBuoiDiemDanh: 17,
  ),
  SinhVien(
    ten: "Phạm Thị D",
    ma: "SV004",
    lop: "CNTT1",
    trangThai: "present",
    soBuoiDiemDanh: 20,
  ),
  SinhVien(
    ten: "Ngô Thị E",
    ma: "SV005",
    lop: "64CNTT",
    trangThai: "absent",
    soBuoiDiemDanh: 14,
  ),
];
