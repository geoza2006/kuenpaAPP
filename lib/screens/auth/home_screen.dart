import 'package:flutter/material.dart';
import 'emergency_contact_screen.dart';
import 'report_screen.dart';
import 'history_screen.dart';
import 'news_screen.dart';
import 'knowledge_screen.dart';
import 'mini_game_screen1.dart'; 
import 'mini_game_screen2.dart';
import 'mini_game_screen3.dart'; 
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---------------------------------------------------------
  // 1. Mock Data สำหรับส่วนที่แอดมินสามารถจัดการได้ (ดึงจาก Backend ในอนาคต)
  // ---------------------------------------------------------
  
  // ข้อมูลสไลด์บาร์
  final List<String> sliderImages = [
    'assets/images/slide_bang.jpg',
    'assets/images/slide_animal.jpg',
    'assets/images/slide_cocodie.jpg',
  ];

  // ข้อมูลหมวดหมู่มินิเกม
  final List<Map<String, String>> miniGameCategories = [
    {
      'title': 'สัตว์ป่าสงวน',
      'image': 'assets/images/game_icon_1.png', 
    },
    {
      'title': 'เต่าทะเล',
      'image': 'assets/images/game_icon_2.png', 
    },
    {
      'title': 'นกเงือก',
      'image': 'assets/images/game_icon_3.png', 
    },
  ];

  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ส่วนที่ 1: โลโก้แนวนอนด้านบนซ้าย
                Image.asset(
                  'assets/images/logo_main.png', 
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),

                // ส่วนที่ 2: สไลด์บาร์รูปภาพ
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
                    Expanded(child: _buildGridButton('เบอร์ติดต่อฉุกเฉิน', 'assets/images/turtle_main.jpg', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmergencyContactScreen()),
                      );                  
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _buildGridButton('ประวัติการพบเจอสัตว์ป่า', 'assets/images/bird_main.jpg', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryScreen()),
                      );  
                    })),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildGridButton('ข่าวสารสัตว์ป่า', 'assets/images/somsej_main.jpg', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewsScreen()),
                      ); 
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _buildGridButton('เกร็ดความรู้', 'assets/images/fish_main.jpg', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const KnowledgeScreen()),
                      );
                    })),
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

                // ลิสต์หมวดหมู่มินิเกม
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: miniGameCategories.length,
                  itemBuilder: (context, index) {
                    return _buildMiniGameItem(
                      miniGameCategories[index]['title']!,
                      miniGameCategories[index]['image']!,
                      () {
                        //2. เช็คจาก index ว่าผู้ใช้กดปุ่มไหน เพื่อให้ไปหน้าแยกกัน
                        Widget targetScreen;
                        
                        if (index == 0) {
                          // index 0 คือกล่องบนสุด (สัตว์ป่าสงวน)
                          targetScreen = const MiniGameScreen1();
                        } else if (index == 1) {
                          // index 1 คือกล่องตรงกลาง (เต่าทะเล)
                          targetScreen = const MiniGameScreen3(); // ใส่ 1 ไว้ชั่วคราวกันแอปแดง
                        } else {
                          // index 2 คือกล่องล่างสุด (นกเงือก)
                          targetScreen = const MiniGameScreen2(); // ใส่ 1 ไว้ชั่วคราวกันแอปแดง
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => targetScreen,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),

      // ---------------------------------------------------------
      // ส่วนที่ 5: Bottom Navigation Bar
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()),);
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
                onPressed: () {
                  // หน้าโฮมอยู่แล้ว ไม่ต้องทำอะไร หรือสามารถเลื่อน Scroll กลับไปบนสุดได้
                },
              ),
              const SizedBox(width: 48), 
              IconButton(
                icon: const Icon(Icons.account_circle, size: 35, color: Colors.white),
                onPressed: () {        
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Widget Builder Functions
  // ---------------------------------------------------------
  Widget _buildGridButton(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath), 
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), 
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

  Widget _buildMiniGameItem(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFEBEBEB), 
          borderRadius: BorderRadius.circular(10), 
        ),
        child: Row(
          children: [
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