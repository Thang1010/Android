import 'chitiet_sv_diemdanh_model.dart';
import 'sinhvien_model.dart';

class BuoiHoc {
  // ===== Thông tin chung =====
  final String tenMon;
  final String lop;
  final String phong;

  // ===== Thông tin điểm danh =====
  final int? diemDanhHienTai;
  final int? tongSoBuoi;

  // ===== Thông tin lịch dạy =====
  final String? thoiGian;
  final DateTime? ngay;
  final String? ki;
  final String? namHoc;
  final String? tuan;

  // ===== Danh sách sinh viên =====
  final List<SinhVien> danhSachSinhVien;

  // ===== Chi tiết điểm danh từng sinh viên =====
  final Map<String, List<DiemDanhBuoiHocChiTiet>> diemDanhChiTietCuaSV;

  BuoiHoc({
    required this.tenMon,
    required this.lop,
    required this.phong,
    this.diemDanhHienTai,
    this.tongSoBuoi,
    this.thoiGian,
    this.ngay,
    this.ki,
    this.namHoc,
    this.tuan,
    this.danhSachSinhVien = const [],
    Map<String, List<DiemDanhBuoiHocChiTiet>>? diemDanhChiTietCuaSV,
  }) : diemDanhChiTietCuaSV = diemDanhChiTietCuaSV ?? {};

  // ===== Getter tỉ lệ điểm danh của lớp =====
  double get tiLeDiemDanh {
    if (diemDanhHienTai == null || tongSoBuoi == null || tongSoBuoi == 0) {
      return 0;
    }
    return (diemDanhHienTai! / tongSoBuoi!).clamp(0.0, 1.0);
  }

  // ===== Getter tỉ lệ điểm danh từng sinh viên =====
  double tiLeDiemDanhCuaSinhVien(SinhVien sv) {
    if (tongSoBuoi == null || tongSoBuoi == 0) return 0;
    return (sv.soBuoiDiemDanh / tongSoBuoi!).clamp(0.0, 1.0);
  }

  // ===== Hàm helper nối chi tiết điểm danh =====
  static List<BuoiHoc> buildWithChiTiet(
      List<BuoiHoc> quanLyLop, List<BuoiHoc> lichDay) {
    return quanLyLop.map((lop) {
      final match = lichDay.firstWhere(
            (b) => b.tenMon == lop.tenMon && b.lop == lop.lop && b.phong == lop.phong,
        orElse: () => BuoiHoc(
          tenMon: lop.tenMon,
          lop: lop.lop,
          phong: lop.phong,
          diemDanhHienTai: lop.diemDanhHienTai,
          tongSoBuoi: lop.tongSoBuoi,
          danhSachSinhVien: lop.danhSachSinhVien,
        ),
      );

      return BuoiHoc(
        tenMon: lop.tenMon,
        lop: lop.lop,
        phong: lop.phong,
        diemDanhHienTai: lop.diemDanhHienTai,
        tongSoBuoi: lop.tongSoBuoi,
        thoiGian: match.thoiGian,
        ngay: match.ngay,
        ki: match.ki,
        namHoc: match.namHoc,
        tuan: match.tuan,
        danhSachSinhVien: lop.danhSachSinhVien,
        diemDanhChiTietCuaSV: match.diemDanhChiTietCuaSV,
      );
    }).toList();
  }

  // =================== DỮ LIỆU MẪU QUẢN LÝ LỚP ===================
  static final List<BuoiHoc> lichDayQuanLyLop = [
    BuoiHoc(
      lop: "CNTT1",
      tenMon: "Lập trình Flutter",
      phong: "B203",
      diemDanhHienTai: 20,
      tongSoBuoi: 45,
      danhSachSinhVien: [
        SinhVien(ma: "SV001", ten: "Nguyễn Văn A", lop: "CNTT1", trangThai: "present", soBuoiDiemDanh: 20),
        SinhVien(ma: "SV002", ten: "Trần Thị B", lop: "CNTT1", trangThai: "absent", soBuoiDiemDanh: 15),
      ],
    ),
    BuoiHoc(
      lop: "CNTT2",
      tenMon: "Cơ sở dữ liệu",
      phong: "C101",
      diemDanhHienTai: 12,
      tongSoBuoi: 20,
      danhSachSinhVien: [
        SinhVien(ma: "SV003", ten: "Lê Văn C", lop: "CNTT2", trangThai: "late", soBuoiDiemDanh: 17),
        SinhVien(ma: "SV004", ten: "Phạm Thị D", lop: "CNTT2", trangThai: "present", soBuoiDiemDanh: 20),
      ],
    ),
  ];

  // =================== DỮ LIỆU MẪU LỊCH DẠY (Dashboard) ===================
  static final List<BuoiHoc> lichDayLichDayScreen = [
    BuoiHoc(
      lop: "CNTT1",
      tenMon: "Lập trình Flutter",
      phong: "B203",
      thoiGian: "07:00 - 09:00",
      ngay: DateTime(2025, 11, 4),
      ki: "Kì 1",
      namHoc: "2025-2026",
      tuan: "Tuần 5",
      tongSoBuoi: 45,
      diemDanhHienTai: 20,
      danhSachSinhVien: [
        SinhVien(ma: "SV001", ten: "Nguyễn Văn A", lop: "CNTT1", trangThai: "present", soBuoiDiemDanh: 20),
        SinhVien(ma: "SV002", ten: "Trần Thị B", lop: "CNTT1", trangThai: "absent", soBuoiDiemDanh: 15),
      ],
      diemDanhChiTietCuaSV: {
        "SV001": [
          DiemDanhBuoiHocChiTiet(
            monHoc: "Lập trình Flutter",
            lop: "CNTT1",
            ngay: DateTime(2025, 10, 1),
            gio: DateTime(2025, 10, 1, 7, 5),
            phong: "B203",
            trangThai: "present",
          ),
          DiemDanhBuoiHocChiTiet(
            monHoc: "Lập trình Flutter",
            lop: "CNTT1",
            ngay: DateTime(2025, 10, 3),
            gio: DateTime(2025, 10, 3, 7, 10),
            phong: "B203",
            trangThai: "late",
          ),
        ],
        "SV002": [
          DiemDanhBuoiHocChiTiet(
            monHoc: "Lập trình Flutter",
            lop: "CNTT1",
            ngay: DateTime(2025, 10, 1),
            gio: DateTime(2025, 10, 1, 7, 5),
            phong: "B203",
            trangThai: "absent",
          ),
        ],
      },
    ),
    BuoiHoc(
      lop: "CNTT2",
      tenMon: "Cơ sở dữ liệu",
      phong: "C101",
      thoiGian: "09:00 - 11:00",
      ngay: DateTime(2025, 11, 5),
      ki: "Kì 1",
      namHoc: "2025-2026",
      tuan: "Tuần 5",
      tongSoBuoi: 20,
      diemDanhHienTai: 12,
      danhSachSinhVien: [
        SinhVien(ma: "SV003", ten: "Lê Văn C", lop: "CNTT2", trangThai: "late", soBuoiDiemDanh: 17),
        SinhVien(ma: "SV004", ten: "Phạm Thị D", lop: "CNTT2", trangThai: "present", soBuoiDiemDanh: 20),
      ],
      diemDanhChiTietCuaSV: {
        "SV003": [
          DiemDanhBuoiHocChiTiet(
            monHoc: "Cơ sở dữ liệu",
            lop: "CNTT2",
            ngay: DateTime(2025, 10, 2),
            gio: DateTime(2025, 10, 2, 9, 0),
            phong: "C101",
            trangThai: "late",
          ),
        ],
        "SV004": [
          DiemDanhBuoiHocChiTiet(
            monHoc: "Cơ sở dữ liệu",
            lop: "CNTT2",
            ngay: DateTime(2025, 10, 2),
            gio: DateTime(2025, 10, 2, 9, 0),
            phong: "C101",
            trangThai: "present",
          ),
        ],
      },
    ),
  ];
}
