import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManageUsersScreen extends StatelessWidget {
  const AdminManageUsersScreen({super.key});

  // ฟังก์ชันอัปเดตยศ
  Future<void> _updateUserRole(String docId, String newRole) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'role': newRole,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการสิทธิ์ผู้ใช้งาน', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700], // สีแดงให้รู้ว่าเป็นหน้าแอดมิน
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลผู้ใช้'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;
              String docId = users[index].id;
              String name = userData['name'] ?? 'ไม่มีชื่อ';
              String email = userData['email'] ?? 'ไม่มีอีเมล';
              String currentRole = userData['role'] ?? 'user'; // ค่าเริ่มต้นคือ user

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: currentRole == 'admin' ? Colors.red : (currentRole == 'officer' ? Colors.blue : Colors.green),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(email),
                  trailing: DropdownButton<String>(
                    value: currentRole,
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('ประชาชน')),
                      DropdownMenuItem(value: 'officer', child: Text('เจ้าหน้าที่')),
                      DropdownMenuItem(value: 'admin', child: Text('แอดมิน')),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _updateUserRole(docId, newValue);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}