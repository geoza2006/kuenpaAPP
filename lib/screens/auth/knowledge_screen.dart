import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_screen.dart';
// import 'profile_screen.dart'; // 📌 เตรียมไว้สำหรับ Import หน้าโปรไฟล์ในอนาคต

// =========================================================
// --- Models สำหรับเก็บข้อมูลเกร็ดความรู้ ---
// =========================================================
class AnimalItem {
  final String name;
  final String imageUrl;

  AnimalItem({required this.name, required this.imageUrl});
}

class AnimalGroup {
  final String groupName;
  final List<AnimalItem> animals;

  AnimalGroup({required this.groupName, required this.animals});
}

class KnowledgeCategory {
  final String title;
  final String coverImageUrl;
  final String description;
  final List<AnimalGroup> groups; // 1 หมวดหมู่ มีได้หลายกลุ่ม (เช่น สัตว์เลี้ยงลูกด้วยนม, นก, เลื้อยคลาน)

  KnowledgeCategory({
    required this.title,
    required this.coverImageUrl,
    required this.description,
    required this.groups,
  });
}

// =========================================================
// หน้าจอที่ 1: หน้าหมวดหมู่เกร็ดความรู้ (Knowledge Screen)
// =========================================================
class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  // --- ข้อมูลจำลอง (Mock Data) ---
  final List<KnowledgeCategory> categories = [
    KnowledgeCategory(
      title: 'สัตว์ป่าสงวนของไทย\nTHAILAND\'S RESERVED WILDLIFE',
      coverImageUrl: 'assets/images/k1_reserved.png',
      description: 'ปัจจุบันประเทศไทยมี "สัตว์ป่าสงวน" (Reserved Wild Animals) ทั้งหมด 21 ชนิดครับ\n'
          'โดยมีการอัปเดตเพิ่มเติมนกชนหินและวาฬสีน้ำเงินเข้ามาเป็นสมาชิกล่าสุดตามกฎหมาย '
          'เพื่อยกระดับการอนุรักษ์อย่างเข้มงวด',
      groups: [
        AnimalGroup(
          groupName: '🦌 จำพวกสัตว์เลี้ยงลูกด้วยนม (15 ชนิด)',
          animals: [
            AnimalItem(name: '1. กระซู่ (Sumatran Rhinoceros)', imageUrl: 'assets/images/k1_animal1.jpg'),
            AnimalItem(name: '2. กวางผา (Burmese Goral)', imageUrl: 'assets/images/k1_animal2.jpg'),
            AnimalItem(name: '3. กูปรี หรือ โคไพร (Kouprey)', imageUrl: 'assets/images/k1_animal3.jpg'),
            AnimalItem(name: '4. เก้งหม้อ (Fea\'s Muntjac)', imageUrl: 'assets/images/k1_animal4.jpg'),
          ],
        ),
      ],
    ),
    KnowledgeCategory(
      title: 'เต่าทะเลของไทย\nTHAILAND\'S SEA TURTLES',
      coverImageUrl: 'assets/images/k2_turtles.png',
      description: 'ข้อมูลเต่าทะเลของไทย...',
      groups: [],
    ),
    KnowledgeCategory(
      title: 'นกเงือกของไทย\nTHAILAND\'S HORNBILLS',
      coverImageUrl: 'assets/images/k3_hornbills.png',
      description: 'ข้อมูลนกเงือกของไทย...',
      groups: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัวข้อ "เกร็ดความรู้"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "เกร็ดความรู้",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
            ),
          ),
          
          // รายการหมวดหมู่ (หน้าปก)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16), // เว้นให้แถบล่าง
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    // กดแล้วไปหน้ารายละเอียด
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeDetailScreen(category: category),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // รูปหน้าปก
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            category.coverImageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 200, width: double.infinity, color: Colors.grey[400],
                              child: const Icon(Icons.image, color: Colors.white, size: 50),
                            ),
                          ),
                        ),
                        // ป้ายชื่อหมวดหมู่ด้านล่าง (จำลองดีไซน์ในรูป)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6C8A1), // สีครีมๆ แบบในดีไซน์
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF5A4D3B), width: 2), // ขอบสีน้ำตาลเข้ม
                          ),
                          child: Text(
                            category.title.split('\n')[0], // เอาแค่บรรทัดแรก (ภาษาไทย)
                            style: const TextStyle(
                              color: Color(0xFF5A4D3B),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // --- แถบเมนูด้านล่าง ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCameraButton() {
    return Container(
      height: 75, width: 75, margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF2E5B2C),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.white, width: 4),
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 35),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: const Color(0xFF2E5B2C),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 35), 
              onPressed: () {
                // 📌 ใช้ pushAndRemoveUntil เพื่อล้าง stack ป้องกันแอปหนัก
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false, 
                );
              }
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), 
              onPressed: () {
                // 📌 TODO: นำคอมเมนต์ออกเมื่อสร้างหน้า ProfileScreen เสร็จแล้ว
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
                */
              }
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// หน้าจอที่ 2: หน้ารายละเอียดหมวดหมู่ (Knowledge Detail Screen)
// =========================================================
class KnowledgeDetailScreen extends StatelessWidget {
  final KnowledgeCategory category;

  const KnowledgeDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // เว้นให้แถบล่าง
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // หัวข้อหลัก (เช่น สัตว์ป่าสงวนของไทย)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                category.title.split('\n')[0], // เอาเฉพาะภาษาไทย
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
              ),
            ),
            const SizedBox(height: 12),
            
            // คำอธิบาย
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                category.description,
                style: const TextStyle(fontSize: 16, color: Color(0xFF4A4A4A), height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            
            // วนลูปแสดงกลุ่มสัตว์และรายชื่อสัตว์
            ...category.groups.map((group) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อกลุ่ม (เช่น จำพวกสัตว์เลี้ยงลูกด้วยนม)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      group.groupName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // รายชื่อสัตว์ในกลุ่มนั้น
                  ...group.animals.map((animal) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // รูปสัตว์
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              animal.imageUrl,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 180, width: double.infinity, color: Colors.grey[200],
                                child: const Icon(Icons.image, color: Colors.grey, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ชื่อสัตว์
                          Text(
                            animal.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16), // เว้นระยะห่างระหว่างสัตว์แต่ละตัว
                        ],
                      ),
                    );
                  }).toList(), // จบลูปสัตว์
                ],
              );
            }).toList(), // จบลูปกลุ่มสัตว์
          ],
        ),
      ),
      // --- แถบเมนูด้านล่าง ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCameraButton(context),
      bottomNavigationBar: _buildBottomNavBar(context)
    );
  }

  // แยก Widget ปุ่มกล้องและ Nav Bar ออกมาเพื่อให้โค้ดอ่านง่ายขึ้นครับ
  Widget _buildCameraButton(BuildContext context) {
    return Container(
      height: 75, width: 75, margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF2E5B2C),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Colors.white, width: 4),
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 35),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF2E5B2C),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white, size: 35), 
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false, 
                );
              }
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), 
              onPressed: () {
                /*
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
                */
              }
            ),
          ],
        ),
      ),
    );
  }
}