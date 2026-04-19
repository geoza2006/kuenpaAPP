import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfficerDashboardScreen extends StatelessWidget {
  const OfficerDashboardScreen({super.key});

  // ฟังก์ชันอัปเดตสถานะ
  Future<void> _updateReportStatus(BuildContext context, String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('reports').doc(docId).update({
      'status': newStatus,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('อัปเดตสถานะเป็น "$newStatus" เรียบร้อย!'), backgroundColor: Colors.green),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'รอดำเนินการ': return Colors.orange;
      case 'กำลังดำเนินการ': return Colors.blue;
      case 'เสร็จสิ้น': return Colors.green;
      case 'ปฏิเสธ': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการแจ้งเหตุ (สำหรับเจ้าหน้าที่)', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800], // สีน้ำเงินสำหรับเจ้าหน้าที่
      ),
      body: StreamBuilder<QuerySnapshot>(
        // ดึงรายงานทั้งหมด
        stream: FirebaseFirestore.instance.collection('reports').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่มีรายการแจ้งเหตุ'));
          }

          var reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var reportData = reports[index].data() as Map<String, dynamic>;
              String docId = reports[index].id; // 📌 สำคัญมาก! ต้องใช้ ID ของเอกสารในการอัปเดต
              String title = reportData['title'] ?? 'ไม่มีหัวข้อ';
              String status = reportData['status'] ?? 'รอดำเนินการ';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('สถานะปัจจุบัน: $status'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                  onTap: () {
                    _showStatusUpdateDialog(context, docId, title, status);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, String docId, String title, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('อัปเดตสถานะ: $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusButton(context, docId, 'รอดำเนินการ', Colors.orange),
              const SizedBox(height: 10),
              _buildStatusButton(context, docId, 'กำลังดำเนินการ', Colors.blue),
              const SizedBox(height: 10),
              _buildStatusButton(context, docId, 'เสร็จสิ้น', Colors.green),
              const SizedBox(height: 10),
              _buildStatusButton(context, docId, 'ปฏิเสธ', Colors.red),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(BuildContext context, String docId, String statusName, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: () {
          _updateReportStatus(context, docId, statusName);
          Navigator.pop(context); // ปิด Dialog
        },
        child: Text(statusName, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}