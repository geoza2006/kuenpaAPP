import 'package:flutter/material.dart';
import 'emergency_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---------------------------------------------------------
  // 1. Mock Data สำหรับส่วนที่แอดมินสามารถจัดการได้ (ดึงจาก Backend ในอนาคต)
  // ---------------------------------------------------------
  
  // ข้อมูลสไลด์บาร์ (แอดมินสามารถ เพิ่ม/ลบ/แก้ไข รูปในนี้ได้จากระบบหลังบ้าน)
  final List<String> sliderImages = [
    'assets/images/slider_elephant.jpg', // ใส่รูปช้าง หรือดึงเป็น NetworkImage ก็ได้
    // 'assets/images/slider_2.jpg',
  ];

  // ข้อมูลหมวดหมู่มินิเกม (แอดมินสามารถ เพิ่ม/ลบ/แก้ไข หมวดหมู่ได้)
  final List<Map<String, String>> miniGameCategories = [
    {
      'title': 'สัตว์ป่าสงวน',
      'image': 'assets/images/game_icon_1.png', // ไอคอนรวมสัตว์
    },
    {
      'title': 'เต่าทะเล',
      'image': 'assets/images/game_icon_2.png', // ไอคอนเต่าทะเล
    },
    {
      'title': 'นกเงือก',
      'image': 'assets/images/game_icon_3.png', // ไอคอนนกเงือก
    },
  ];

  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea ช่วยไม่ให้เนื้อหาไปทับกับ Notch หรือ Status Bar ของมือถือ
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ส่วนที่ 1: โลโก้แนวนอนด้านบนซ้าย
                Image.asset(
                  'assets/images/logo_main.png', // ชื่อไฟล์ตามที่คุณระบุ
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),

                // ส่วนที่ 2: สไลด์บาร์รูปภาพ (ใช้ PageView หรือแค่ Container ถ้ารูปเดียว)
                // ในที่นี้ทำเป็น PageView เผื่อแอดมินใส่หลายรูปให้เลื่อนได้
                SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: PageView.builder(
                      itemCount: sliderImages.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          sliderImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ส่วนที่ 3: 4 ปุ่มหลัก (กริด)
                Row(
                  children: [
                    Expanded(child: _buildGridButton('เบอร์ติดต่อฉุกเฉิน', 'assets/images/menu_turtle.png', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmergencyContactScreen()),
                      );                   
                      })),
                    const SizedBox(width: 10),
                    Expanded(child: _buildGridButton('ประวัติการพบเจอสัตว์ป่า', 'assets/images/menu_hornbill.png', () {})),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildGridButton('ข่าวสารสัตว์ป่า', 'assets/images/menu_tapir.png', () {})),
                    const SizedBox(width: 10),
                    Expanded(child: _buildGridButton('เกร็ดความรู้', 'assets/images/menu_dugong.png', () {})),
                  ],
                ),
                const SizedBox(height: 25),

                // ส่วนที่ 4: มินิเกม (หัวข้อ)
                const Text(
                  'มินิเกม',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // ลิสต์หมวดหมู่มินิเกม (จะเพิ่มขึ้นหรือลดลงตาม List miniGameCategories ที่ดึงมาจากแอดมิน)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // ปิดการ scroll ซ้อน
                  itemCount: miniGameCategories.length,
                  itemBuilder: (context, index) {
                    return _buildMiniGameItem(
                      miniGameCategories[index]['title']!,
                      miniGameCategories[index]['image']!,
                      () {
                        // กดแล้วไปหน้าคำถามของหมวดหมู่นี้
                      },
                    );
                  },
                ),
                const SizedBox(height: 30), // เว้นที่ว่างให้ Bottom Navigation Bar
              ],
            ),
          ),
        ),
      ),

      // ---------------------------------------------------------
      // ส่วนที่ 5: Bottom Navigation Bar แบบ Custom (มีปุ่มกล้องตรงกลาง)
      // ---------------------------------------------------------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4), // ขอบสีขาวรอบปุ่ม
        ),
        child: FloatingActionButton(
          onPressed: () {
            // โค้ดเปิดกล้อง / หน้าแจ้งเรื่อง
          },
          backgroundColor: const Color(0xFF1B803B), // สีเขียวสว่าง
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt, size: 35, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E5631), // สีเขียวเข้มแบบในภาพ
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ปุ่มโฮม (ซ้าย)
              IconButton(
                icon: const Icon(Icons.home, size: 35, color: Colors.white),
                onPressed: () {
                  // อยู่หน้าโฮมอยู่แล้ว
                },
              ),
              const SizedBox(width: 48), // เว้นที่ตรงกลางไว้ให้ปุ่มกล้อง
              // ปุ่มโปรไฟล์ (ขวา)
              IconButton(
                icon: const Icon(Icons.account_circle, size: 35, color: Colors.white),
                onPressed: () {
                  // ไปหน้าโปรไฟล์
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Widget Builder Functions (ตัวช่วยสร้าง UI เพื่อให้โค้ดสะอาด)
  // ---------------------------------------------------------

  // ฟังก์ชันสร้าง 4 ปุ่มหลัก
  Widget _buildGridButton(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            // ใช้รูปภาพเป็นพื้นหลัง (อย่าลืมเตรียมรูปเหล่านี้ไว้ในโฟลเดอร์ assets)
            image: AssetImage(imagePath), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), // ทำฟิลเตอร์ให้รูปดูจางลงแบบในดีไซน์ เพื่อให้เห็นตัวอักษรชัดขึ้น
              BlendMode.lighten,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างแถบหมวดหมู่มินิเกม
  Widget _buildMiniGameItem(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10), // ระยะห่างระหว่างแถว
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB), // สีพื้นหลังเทาอ่อนแบบในดีไซน์
          borderRadius: BorderRadius.circular(10), // มุมมนนิดๆ หรือลบออกถ้าต้องการเหลี่ยม
        ),
        child: Row(
          children: [
            // ส่วนรูปภาพด้านซ้าย
            Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ส่วนข้อความ
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}