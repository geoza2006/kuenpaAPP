import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_screen.dart'; 
import 'home_screen.dart';
import 'report_screen.dart';
import 'report_history_screen.dart';
import 'admin_manage_users.dart';
import 'officer_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ตัวแปรข้อมูลผู้ใช้
  String userName = "กำลังโหลด..."; 
  
  // จำลองสถิติที่ดึงมาจากหน้า Report
  int totalReports = 4;
  int savedAnimals = 2;

  // จัดการรูปโปรไฟล์
  File? _profileImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  // ดึงชื่อผู้ใช้จาก Firebase Auth 
  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userName = currentUser.displayName ?? currentUser.email ?? "ผู้ใช้งาน (ไม่ระบุชื่อ)";
      });
    }
  }

  // ฟังก์ชันเลือกรูปโปรไฟล์ใหม่
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // ฟังก์ชันออกจากระบบ
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. พื้นหลังโค้งสีเขียวอ่อนด้านบน ---
          ClipPath(
            clipper: HeaderCurveClipper(),
            child: Container(
              height: 250,
              color: const Color(0xFFC1D8B4), 
            ),
          ),

          // ปุ่มย้อนกลับ
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "โปรไฟล์",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 73, 23)),
                    ),
                  ),
                  const SizedBox(width: 48), // ดันให้คำว่าโปรไฟล์อยู่ตรงกลาง
                ],
              ),
            ),
          ),

          //เนื้อหาหลัก
          SafeArea(
            child: SingleChildScrollView( // 📌 เปลี่ยนมาใช้ ScrollView เพื่อไม่ให้จอ Error ตอนปุ่มโผล่เยอะๆ
              child: Column(
                children: [
                  const SizedBox(height: 70), 
                  
                  // รูปโปรไฟล์
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4), 
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage('assets/images/profile.png') as ImageProvider, 
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.grey, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ชื่อผู้ใช้
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E5B2C)),
                  ),
                  
                  //ดึง Role และแสดงปุ่มตามสิทธิ์
                  StreamBuilder<DocumentSnapshot>(
                    stream: currentUser != null
                        ? FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots()
                        : const Stream.empty(),
                    builder: (context, snapshot) {
                      String role = 'user';
                      String displayRole = 'ผู้ใช้ทั่วไป';

                      if (snapshot.hasData && snapshot.data!.exists) {
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        role = userData['role'] ?? 'user';
                        
                        if (role == 'admin') displayRole = 'ผู้ดูแลระบบ (Admin)';
                        else if (role == 'officer') displayRole = 'เจ้าหน้าที่';
                      }

                      return Column(
                        children: [
                          // แสดงสถานะ
                          Text(
                            displayRole,
                            style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),

                          // กล่องสถิติ
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFC8F93),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "แจ้งเหตุแล้ว:\n$totalReports ครั้ง",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF90F585),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ช่วยสัตว์ปลอดภัย:\n$savedAnimals ตัว",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          //โซนปุ่มเมนูต่างๆ
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                // 1. ปุ่มประวัติการแจ้งเหตุ (เห็นทุกคน)
                                _buildMenuButton(
                                  title: "ประวัติการแจ้งเหตุ",
                                  bgColor: const Color(0xFFEBEBEB),
                                  textColor: Colors.black87,
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportHistoryScreen()));
                                  },
                                ),
                                const SizedBox(height: 15),

                                // ปุ่มเจ้าหน้าที่
                                if (role == 'officer' || role == 'admin') ...[
                                  _buildMenuButton(
                                    title: "รับเรื่องแจ้งเหตุ (เจ้าหน้าที่)",
                                    bgColor: Colors.blue[100]!,
                                    textColor: Colors.blue[800]!,
                                    icon: Icons.assignment_turned_in,
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OfficerDashboardScreen()));
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                ],

                                //ปุ่มแอดมิน
                                if (role == 'admin') ...[
                                  _buildMenuButton(
                                    title: "จัดการยศผู้ใช้ (แอดมิน)",
                                    bgColor: Colors.purple[100]!,
                                    textColor: Colors.purple[800]!,
                                    icon: Icons.manage_accounts,
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminManageUsersScreen()));
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // ปุ่มออกจากระบบ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _logout, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("ออกจากระบบ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // ระยะห่างเผื่อพื้นที่ให้ NavBar ด้านล่าง
                ],
              ),
            ),
          ),
        ],
      ),

      //แถบเมนูด้านล่าง
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(context),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildMenuButton({required String title, required Color bgColor, required Color textColor, IconData? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: bgColor, 
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraButton(BuildContext context) {
    return Container(
      height: 70, width: 70, margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: Colors.white, shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4), 
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
        },
        backgroundColor: const Color(0xFF1B803B),
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 35),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF1E5631),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white54, size: 35), 
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false, 
                );
              }
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), 
              onPressed: () {}
            ),
          ],
        ),
      ),
    );
  }
}

// คลาสวาดเส้นโค้งพื้นหลังสีเขียวด้านบน
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); 
    path.quadraticBezierTo(
      size.width / 2, size.height, 
      size.width, size.height - 50, 
    );
    path.lineTo(size.width, 0); 
    path.close(); 
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}