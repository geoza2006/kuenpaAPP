import 'package:flutter/material.dart';

// --- สร้าง Model สำหรับจำลองข้อมูล ---
class EncounterLocation {
  final String locationName;
  final List<EncounterAnimal> animals; // 1 สถานที่ มีสัตว์ได้หลายตัว

  EncounterLocation({required this.locationName, required this.animals});
}

class EncounterAnimal {
  final String name;
  final String imageUrl;

  EncounterAnimal({required this.name, required this.imageUrl});
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // --- จำลองข้อมูล (Mock Data) สถานที่และสัตว์ป่าที่เจอ ---
  final List<EncounterLocation> historyData = [
    EncounterLocation(
      locationName: "อุทยานแห่งชาติสิรินาถ จ.ภูเก็ต",
      animals: [
        EncounterAnimal(
          name: "เต่าทะเล",
          imageUrl: "assets/images/h1_turtle.jpg",
        ),
        // ตัวอย่างการซ้อนรูปถ้าเจอ 2 ตัวในที่เดียวกัน (สไลด์ซ้ายขวาได้)
        EncounterAnimal(
          name: "ปูลม",
          imageUrl: "assets/images/h1_crab.jpg",
        ),
      ],
    ),
    EncounterLocation(
      locationName: "เขตรักษาพันธุ์สัตว์ป่าห้วยขาแข้ง จ.อุทัยธานี",
      animals: [
        EncounterAnimal(
          name: "เสือโคร่งไทย",
          imageUrl: "assets/images/h2_tiger.jpg",
        ),
      ],
    ),
    EncounterLocation(
      locationName: "อุทยานแห่งชาติลำคลองงู จ.กาญจนบุรี",
      animals: [
        EncounterAnimal(
          name: "สมเสร็จ",
          imageUrl: "assets/images/h2_somsej.jpg",
        ),
      ],
    ),
  ];

  // ฟังก์ชันสำหรับกดดูรูปใหญ่
  void _showFullImage(BuildContext context, EncounterAnimal animal) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // รูปใหญ่
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                // ⚠️ แก้ตรงนี้เป็น Image.asset ⚠️
                child: Image.asset(animal.imageUrl, fit: BoxFit.contain),
              ),
            ),
            // ปุ่มปิด (กากบาท)
            Positioned(
              top: -10,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.white, size: 40),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- แถบด้านบน (AppBar) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "ประวัติการพบเจอสัตว์ป่า",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),

      // --- เนื้อหาหลัก (รายการสถานที่) ---
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100), // เว้นที่ให้แถบเมนูด้านล่าง
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final location = historyData[index];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. โชว์หมุดสถานที่
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location.locationName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 2. โชว์รูปสัตว์ (ถ้ามีหลายตัว จะเลื่อนซ้ายขวาได้)
                SizedBox(
                  height: 200, // ความสูงของรูป
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: location.animals.length,
                    itemBuilder: (context, animalIndex) {
                      final animal = location.animals[animalIndex];
                      
                      return GestureDetector(
                        onTap: () => _showFullImage(context, animal), // กดเพื่อดูรูปใหญ่
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32, // กว้างเต็มจอหักขอบ
                          margin: const EdgeInsets.only(right: 12.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // รูปภาพ
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                // ⚠️ แก้ตรงนี้เป็น Image.asset ⚠️
                                child: Image.asset(
                                  animal.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // แถบดำๆ ดรอปเงาข้างล่างให้อ่านชื่อสัตว์ชัดขึ้น
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                    ),
                                  ),
                                ),
                              ),
                              // ชื่อสัตว์ป่า
                              Positioned(
                                bottom: 12,
                                left: 16,
                                child: Text(
                                  animal.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // ถ้ามีสัตว์มากกว่า 1 ตัว ให้โชว์ไอคอนสไลด์
                              if (location.animals.length > 1)
                                const Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Icon(Icons.swipe, color: Colors.white70, size: 28),
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
          );
        },
      ),

      // --- ปุ่มกล้องตรงกลาง (ลอยๆ) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        margin: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          onPressed: () {
            // ไปหน้ากล้องหรือหน้ารายงาน
          },
          backgroundColor: const Color(0xFF2E5B2C), // สีเขียวตามดีไซน์
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.white, width: 4), // ขอบสีขาว
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 35),
        ),
      ),

      // --- แถบเมนูด้านล่าง (Bottom Navigation Bar) ---
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2E5B2C), // สีเขียวเข้ม
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
                  // กลับหน้าโฮม
                },
              ),
              const SizedBox(width: 40), // เว้นที่ให้ปุ่มกล้องตรงกลาง
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white, size: 35),
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
}