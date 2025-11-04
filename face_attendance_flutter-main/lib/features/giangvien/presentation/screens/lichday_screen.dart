import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../gv_routes.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';

class LichDayScreen extends StatefulWidget {
  final String giangVienId;

  const LichDayScreen({super.key, required this.giangVienId});

  @override
  State<LichDayScreen> createState() => _LichDayScreenState();
}

class _LichDayScreenState extends State<LichDayScreen> {
  final int _currentIndex = 1; // Lịch dạy
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedTerm = 'Kì 1';
  String selectedYear = '';
  String selectedWeek = 'Tuần 1';

  late List<String> years;
  final List<String> terms = ['Kì 1', 'Kì 2'];
  final List<String> weeks = List.generate(10, (index) => 'Tuần ${index + 1}');
  DateTime selectedDate = DateTime.now();

  // ✅ Dữ liệu từ model
  late List<BuoiHoc> lichDayHomNay;
  List<BuoiHoc> displayedBuoiHoc = [];
  bool isFilteringByDate = true;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    years = [for (int start = 2020; start <= currentYear; start++) '$start-${start + 1}'];
    selectedYear = years.last;

    // Lấy dữ liệu từ model
    lichDayHomNay = BuoiHoc.lichDayLichDayScreen;

    filterByDate(selectedDate);
  }

  void filterByDate(DateTime date) {
    isFilteringByDate = true;
    displayedBuoiHoc = lichDayHomNay
        .where((b) =>
    b.ngay?.year == date.year &&
        b.ngay?.month == date.month &&
        b.ngay?.day == date.day)
        .toList();
    setState(() => selectedDate = date);
  }

  void filterByTermYearWeek() {
    isFilteringByDate = false;
    displayedBuoiHoc = lichDayHomNay
        .where((b) =>
    b.ki == selectedTerm &&
        b.namHoc == selectedYear &&
        b.tuan == selectedWeek)
        .toList();
    setState(() {});
  }

  List<DateTime> generateCalendarDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int weekdayOfFirst = firstDayOfMonth.weekday;
    final int leadingDays = weekdayOfFirst % 7;

    final prevMonth = DateTime(month.year, month.month, 0);
    final int daysInPrevMonth = prevMonth.day;
    List<DateTime> calendar = [];

    for (int i = leadingDays - 1; i >= 0; i--) {
      calendar.add(DateTime(prevMonth.year, prevMonth.month, daysInPrevMonth - i));
    }
    for (int i = 1; i <= daysInMonth; i++) {
      calendar.add(DateTime(month.year, month.month, i));
    }
    int nextDay = 1;
    while (calendar.length < 42) {
      calendar.add(DateTime(month.year, month.month + 1, nextDay));
      nextDay++;
    }
    return calendar;
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = generateCalendarDays(selectedDate);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF0F0F0),
      drawer: GVSideMenu(
        giangVienId: widget.giangVienId,
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            const Text(
              'LỊCH DẠY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không có thông báo mới")),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Bộ lọc ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: selectedTerm,
                  items: terms
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedTerm = v!),
                ),
                DropdownButton(
                  value: selectedYear,
                  items: years
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedYear = v!),
                ),
                DropdownButton(
                  value: selectedWeek,
                  items: weeks
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedWeek = v!),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF154B71)),
                  onPressed: filterByTermYearWeek,
                  child: const Text("Lọc", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          // --- Tháng / Năm ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Color(0xFF154B71)),
                  onPressed: () {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month - 1, 1);
                      if (isFilteringByDate) filterByDate(selectedDate);
                    });
                  },
                ),
                Text(
                  "${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154B71)),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Color(0xFF154B71)),
                  onPressed: () {
                    setState(() {
                      selectedDate =
                          DateTime(selectedDate.year, selectedDate.month + 1, 1);
                      if (isFilteringByDate) filterByDate(selectedDate);
                    });
                  },
                ),
              ],
            ),
          ),
          // --- Thứ ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('T2'),
                Text('T3'),
                Text('T4'),
                Text('T5'),
                Text('T6'),
                Text('T7'),
                Text('CN'),
              ],
            ),
          ),
          // --- Lịch tháng ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calendarDays.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2),
              itemBuilder: (context, index) {
                final day = calendarDays[index];
                final isCurrentMonth = day.month == selectedDate.month;
                final isSelected = day.year == selectedDate.year &&
                    day.month == selectedDate.month &&
                    day.day == selectedDate.day;
                return GestureDetector(
                  onTap: () => filterByDate(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF154B71) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isCurrentMonth
                            ? (isSelected ? Colors.white : Colors.black)
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // --- Danh sách buổi học ---
          Expanded(
            child: displayedBuoiHoc.isEmpty
                ? const Center(child: Text("Không có buổi học"))
                : ListView.builder(
                itemCount: displayedBuoiHoc.length,
                itemBuilder: (context, index) {
                  final b = displayedBuoiHoc[index];
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Color(0xFF154B71)),
                      title: Text(b.tenMon),
                      subtitle: Text(
                          "${b.phong} | ${b.thoiGian ?? ''} | Lớp: ${b.lop}"),
                    ),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 1),
    );
  }
}
