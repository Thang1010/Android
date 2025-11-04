// =================== MODEL MÔN HỌC ===================
class MonHoc {
  final String tenMon;
  final String tenLop;
  final String thu;
  final String tiet;
  final String phong;
  final String trangThai;

  MonHoc({
    required this.tenMon,
    required this.tenLop,
    required this.thu,
    required this.tiet,
    required this.phong,
    required this.trangThai,
  });
}

// =================== DỮ LIỆU MẪU ===================
final List<MonHoc> danhSachMonHoc = [
  MonHoc(
    tenMon: "Lập Trình Android",
    tenLop: "64KTPM.NB",
    thu: "Năm",
    tiet: "1 - 2",
    phong: "325 - A2",
    trangThai: "qua_gio",
  ),
  MonHoc(
    tenMon: "Lập Trình Web",
    tenLop: "64KTPM.NB",
    thu: "Ba",
    tiet: "3 - 5",
    phong: "215 - A1",
    trangThai: "dung_gio",
  ),
  MonHoc(
    tenMon: "CSDL nâng cao",
    tenLop: "64KTPM.NB",
    thu: "Hai",
    tiet: "1 - 3",
    phong: "203 - A1",
    trangThai: "chua_den_gio",
  ),
];
