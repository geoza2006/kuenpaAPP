import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

//รายการประวัติการรายงานทั้งหมด
class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});
  
  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // ฟังก์ชันช่วยจัดรูปแบบวันที่
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'กำลังอัปเดต...';
    DateTime date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year + 543} เวลา ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} น.';
  }

  // ฟังก์ชันเลือกสีของสถานะ
  Color _getStatusColor(String status) {
    switch (status) {
      case 'รอดำเนินการ':
        return Colors.orange;
      case 'กำลังดำเนินการ':
        return Colors.blue;
      case 'เสร็จสิ้น':
        return Colors.green;
      case 'ปฏิเสธ':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // สีพื้นหลังเทาอมฟ้าอ่อนๆ
      appBar: AppBar(
        title: const Text('ประวัติการรายงาน', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: currentUser == null
          ? const Center(child: Text("กรุณาเข้าสู่ระบบเพื่อดูประวัติ"))
          : StreamBuilder<QuerySnapshot>(
              // ดึงเฉพาะข้อมูลของคนที่ Login อยู่
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('userId', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                // เรียงลำดับข้อมูลจากใหม่ไปเก่า (ทำในแอปเพื่อเลี่ยงปัญหา Index ของ Firebase)
                var docs = snapshot.data!.docs;
                docs.sort((a, b) {
                  Timestamp? timeA = a['createdAt'] as Timestamp?;
                  Timestamp? timeB = b['createdAt'] as Timestamp?;
                  if (timeA == null || timeB == null) return 0;
                  return timeB.compareTo(timeA); // ใหม่ขึ้นก่อน
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    String title = data['title'] ?? 'ไม่มีหัวข้อ';
                    String status = data['status'] ?? 'ไม่ทราบสถานะ';
                    String base64String = data['imageBase64'] ?? '';
                    Timestamp? createdAt = data['createdAt'] as Timestamp?;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          // กดแล้วไปหน้ารายละเอียด
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailScreen(reportData: data),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // รูปภาพ Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: base64String.isNotEmpty
                                    ? Image.memory(
                                        base64Decode(base64String), // 📌 แปลงข้อความกลับเป็นรูป
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                                      )
                                    : _buildPlaceholderImage(),
                              ),
                              const SizedBox(width: 16),
                              // ข้อมูล
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatDate(createdAt),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    // ป้ายสถานะ
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: _getStatusColor(status)),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: _getStatusColor(status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // รูปแบบกรณีไม่มีรูปภาพ
  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  // หน้าจอตอนยังไม่มีประวัติ
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('ยังไม่มีประวัติการรายงาน', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}

//หน้ารายละเอียดการรายงาน (คลิกจากการ์ดในหน้ารายการ)
class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportDetailScreen({super.key, required this.reportData});

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
    String imageUrl = reportData['imageUrl'] ?? '';
    String status = reportData['status'] ?? 'ไม่ทราบสถานะ';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('รายละเอียดการแจ้งเหตุ', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนแสดงรูปภาพ (ถ้ามี)
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ส่วนหัวข้อและสถานะ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          reportData['title'] ?? 'ไม่มีหัวข้อ',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),

                  // ข้อมูลรายละเอียดต่างๆ
                  _buildDetailRow(Icons.person, 'ชื่อผู้แจ้ง', reportData['reporterName'] ?? '-'),
                  _buildDetailRow(Icons.phone, 'เบอร์ติดต่อ', reportData['phone'] ?? '-'),
                  _buildDetailRow(Icons.location_on, 'พิกัดที่พบ', reportData['locationText'] ?? '-'),
                  
                  const SizedBox(height: 20),
                  const Text('รายละเอียดเพิ่มเติม:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      reportData['details']?.isEmpty == true ? 'ไม่มีรายละเอียดเพิ่มเติม' : reportData['details'],
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ช่วยสร้างบรรทัดข้อมูล
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2E5B2C), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}