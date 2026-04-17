import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'login_screen.dart'; // 📌 อย่าลืมเปลี่ยนชื่อไฟล์ให้ตรงกับหน้า Login ของคุณ
import 'home_screen.dart';
import 'report_screen.dart';
// import 'report_history_screen.dart'; // 📌 เตรียมไว้สำหรับหน้าประวัติการแจ้งเหตุส่วนตัว

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ---------------------------------------------------------
  // ข้อมูลจำลอง (Mock Data) สำหรับหน้าโปรไฟล์
  // ---------------------------------------------------------
  String userName = "นิธิศ คตดี";
  String userRole = "ผู้ใช้"; // สถานะ: ผู้ใช้, เจ้าหน้าที่, แอดมิน
  
  // จำลองสถิติที่ดึงมาจากหน้า Report
  int totalReports = 4;
  int savedAnimals = 2;

  // จัดการรูปโปรไฟล์
  File? _profileImage;
  final picker = ImagePicker();

  // ฟังก์ชันเลือกรูปโปรไฟล์ใหม่จากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // ---------------------------------------------------------
  // ฟังก์ชันออกจากระบบ (Logout)
  // ---------------------------------------------------------
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        // ใช้ pushAndRemoveUntil เพื่อล้างหน้าต่างทั้งหมด ป้องกันการกด Back กลับมา
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. พื้นหลังโค้งสีเขียวอ่อนด้านบน ---
          ClipPath(
            clipper: HeaderCurveClipper(),
            child: Container(
              height: 250,
              color: const Color(0xFFC1D8B4), // สีเขียวอ่อนแบบในรูป
            ),
          ),

          // --- 2. ปุ่มย้อนกลับ และคำว่า "โปรไฟล์" ---
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

          // --- 3. เนื้อหาหลัก ---
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 70), // เว้นระยะลงมาจากแถบบน
                
                // รูปโปรไฟล์
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4), // ขอบสีขาวรอบรูป
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage('assets/images/profile.png') as ImageProvider, // ⚠️ เปลี่ยนเป็นรูป Default ของคุณ
                        ),
                      ),
                      // ปุ่มแก้ไขรูปภาพ
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

                // ชื่อและสถานะ
                Text(
                  userName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2E5B2C)),
                ),
                Text(
                  userRole, // โชว์ว่าเป็น ผู้ใช้, เจ้าหน้าที่ หรือ แอดมิน
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // กล่องสถิติ (แจ้งเหตุแล้ว / ช่วยสัตว์ปลอดภัย)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFC8F93), // สีแดงอมชมพู
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
                            color: const Color(0xFF90F585), // สีเขียวสว่าง
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
                const SizedBox(height: 20),

                // ปุ่มประวัติการแจ้งเหตุ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      // 📌 TODO: กดแล้วไปหน้าประวัติการแจ้งเหตุของตัวเอง
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEB), // สีเทาอ่อน
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "ประวัติการแจ้งเหตุ",
                        style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                const Spacer(), // ดันปุ่มออกจากระบบไปด้านล่างสุด

                // ปุ่มออกจากระบบ (สีแดง)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _logout, // 📌 เรียกฟังก์ชัน Logout
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("ออกจากระบบ", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // ระยะห่างจากด้านล่างก่อนถึง NavBar
              ],
            ),
          ),
        ],
      ),

      /// --- แถบเมนูด้านล่าง (ปรับให้ปุ่มโปรไฟล์สว่างขึ้น) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(context),
      bottomNavigationBar: _buildBottomNavBar(context),
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
              icon: const Icon(Icons.home, color: Colors.white54, size: 35), // หน้าโปรไฟล์ ให้ไอคอนโฮมดรอปสีลง
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
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), // ไอคอนโปรไฟล์สว่าง 100%
              onPressed: () {
                // อยู่หน้าโปรไฟล์อยู่แล้ว ไม่ต้องทำอะไร
              }
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// คลาสวาดเส้นโค้งพื้นหลังสีเขียวด้านบน
// ---------------------------------------------------------
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // ลากเส้นลงมาด้านซ้ายเกือบสุด
    
    // วาดความโค้ง (จุดควบคุม x,y และ จุดจบ x,y)
    path.quadraticBezierTo(
      size.width / 2, size.height, // จุดที่ดึงให้โค้ง (กึ่งกลางจอ, ล่างสุด)
      size.width, size.height - 50, // จุดจบ (ขวาสุด)
    );
    
    path.lineTo(size.width, 0); // ลากเส้นขึ้นไปมุมขวาบน
    path.close(); // ปิด path กลับไปจุดเริ่มต้น
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}





