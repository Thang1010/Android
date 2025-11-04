import 'package:flutter/material.dart';

class PDTDashboardScreen extends StatelessWidget {
  const PDTDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phòng Đào Tạo Dashboard')),
      body: const Center(
        child: Text(
          'Chào mừng Phòng Đào Tạo 🧾',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
