import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:audioplayers/audioplayers.dart'; // Uncomment เมื่อติดตั้งแพ็กเกจแล้ว

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  // ---------------------------------------------------------
  // Mock Data: ข้อมูลเบอร์ติดต่อที่แอดมินสามารถเพิ่ม/ลบ/แก้ไขได้จากหลังบ้าน
  // ---------------------------------------------------------
  final List<Map<String, String>> emergencyContacts = [
    {'number': '1362', 'name': 'สายด่วนอุทยาน'},
    {'number': '1136', 'name': 'บก.ปทส.'},
    {'number': '02-561-0777', 'name': 'ส่วนคุ้มครองสัตว์ป่า'},
    {'number': '1146', 'name': 'กรมทรัพยากรทางทะเล'},
    {'number': '02-562-0600', 'name': 'ศูนย์ป้องกันและปราบปรามประมง'},
    {'number': '032-476-134', 'name': 'มูลนิธิเพื่อนสัตว์ป่า'},
  ];

  // final AudioPlayer _audioPlayer = AudioPlayer(); // สำหรับเล่นเสียง SOS

  // ---------------------------------------------------------
  // ฟังก์ชัน: โทรออก
  // ---------------------------------------------------------
  Future<void> _makePhoneCall(String phoneNumber) async {
    // ลบขีดกลางออกก่อนโทร (เผื่อระบบโทรศัพท์บางเครื่องไม่รองรับ)
    final String cleanNumber = phoneNumber.replaceAll('-', '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถโทรออกได้ในขณะนี้')),
      );
    }
  }

  // ---------------------------------------------------------
  // ฟังก์ชัน: กดปุ่ม SOS
  // ---------------------------------------------------------
  Future<void> _handleSOS() async {
    // 1. ขอสิทธิ์การเข้าถึงที่จำเป็น (ตำแหน่ง, โทรศัพท์)
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
    ].request();

    if (statuses[Permission.location]!.isGranted) {
      // 2. ดึงตำแหน่งปัจจุบัน (ต้องใช้ geolocator เพิ่มถ้าต้องการพิกัดจริง)
      
      // 3. เล่นเสียงแจ้งเตือนดังๆ
      // await _audioPlayer.play(AssetSource('sounds/alarm.mp3')); // เตรียมไฟล์เสียงใน assets
      
      // 4. ส่งข้อมูลแจ้งเตือนไปยังระบบของแอดมิน (API Call)
      print("ส่งพิกัดและการแจ้งเตือนฉุกเฉินไปยังแอดมินแล้ว!");

      // แสดง Dialog แจ้งผู้ใช้
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('แจ้งเตือนฉุกเฉิน (SOS)'),
          content: const Text('ระบบกำลังส่งตำแหน่งของคุณไปยังแอดมินและเจ้าหน้าที่ที่เกี่ยวข้องแล้ว โปรดรอการติดต่อกลับ'),
          actions: [
            TextButton(
              onPressed: () {
                // _audioPlayer.stop(); // หยุดเสียงเมื่อกดปิด
                Navigator.pop(context);
              },
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
    } else {
      // กรณีผู้ใช้ไม่อนุญาตสิทธิ์
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอนุญาตการเข้าถึงตำแหน่งและเบอร์โทรเพื่อใช้งาน SOS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ส่วนที่ 1: ปุ่มย้อนกลับ
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                ),
              ),
            ),

            // ส่วนที่ 2: หัวข้อ และ ปุ่ม SOS
            const Text(
              'ติดต่อฉุกเฉิน',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _handleSOS, // กดแล้วเรียกฟังก์ชัน SOS
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFFED2224), // สีแดงแบบในภาพ
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ส่วนที่ 3: ลิสต์เบอร์ติดต่อฉุกเฉิน
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return GestureDetector(
                    onTap: () => _makePhoneCall(contact['number']!), // กดเพื่อโทร
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4EFEF), // สีพื้นหลังเทาอมชมพูอ่อนๆ
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Color(0xFF4C7B2F), // ไอคอนโทรศัพท์สีเขียว
                            size: 30,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Text(
                              contact['number']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              contact['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30), // เว้นระยะให้ Bottom Navigation
          ],
        ),
      ),

      // ---------------------------------------------------------
      // ส่วนที่ 4: Bottom Navigation Bar แบบเดียวกับหน้า Home
      // ---------------------------------------------------------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: FloatingActionButton(
          onPressed: () {
            // โค้ดเปิดกล้อง / หน้าแจ้งเรื่อง
          },
          backgroundColor: const Color(0xFF1B803B),
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt, size: 35, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E5631),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, size: 35, color: Colors.white),
                onPressed: () => Navigator.pop(context), // กลับไปหน้าโฮม
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.account_circle, size: 35, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}