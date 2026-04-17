import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'report_screen.dart';

// --- Model สำหรับเก็บข้อมูลข่าว ---
class NewsArticle {
  final String title;
  final String imageUrl;
  final String date;
  final String category;
  final int views;
  final int shares;
  final String content;

  NewsArticle({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.views,
    required this.shares,
    required this.content,
  });
}

// =========================================================
// หน้าจอที่ 1: หน้ารายการข่าวสาร (News Screen)
// =========================================================
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // --- ข้อมูลจำลอง (Mock Data) ---
  final List<NewsArticle> newsList = [
    NewsArticle(
      title: '1 ทศวรรษพญาแร้งคืนถิ่น 8 มีนาคม 2569กรมอุทยานแห่งชาติฯ \nชี้แจงกรณี “เหี้ย” สัตว์ป่าคุ้มครองเพาะพันธุ์ได้ ไม่ใช่ใครก็เลี้ยงได้ ต้องขออนุญาตและตรงตามเงื่อนไขที่กำหนดเท่านั้น!',
      imageUrl: 'assets/images/news1.jpg',
      date: '2 มีนาคม 2026',
      category: 'กิจกรรม',
      views: 360,
      shares: 0,
      content: '3 ก.ค. 68 นายอรรถพล​ เจริญชันษา​ อธิบดีกรมอุทยานแห่งชาติ สัตว์ป่า​ และพันธุ์พืช​ เปิดเผยว่า จากกรณีที่\n'
          '“เหี้ย” (Varanus salvator) ได้รับการประกาศในราชกิจจานุเบกษาให้เป็นสัตว์ป่าคุ้มครองที่สามารถเพาะพันธุ์ได้\n'
          'อย่างเป็นทางการเมื่อปลายปีที่ผ่านมานั้น ขอเรียนชี้แจงและทำความเข้าใจแก่ประชาชนทุกท่านว่า\n'
          '“การเปลี่ยนแปลงสถานะดังกล่าว ไม่ได้หมายความว่าประชาชนทั่วไปจะสามารถจับเหี้ยจากธรรมชาติมาเลี้ยง\n'
          'หรือเพาะพันธุ์เหี้ยได้ทันทีโดยไม่มีข้อกำหนด และไม่ไช่เหี้ยที่อยู่ตามธรรมชาติ แต่เป็นเหี้ยที่อยู่ที่สถานีเพาะเลี้ยงที่ได้\n'
          'รับอนุญาตให้จำหน่ายเพื่อให้ผู้ได้รับอนุญาตนำไปเพาะขยายพันธุ์เท่านั้น”',
    ),
    NewsArticle(
      title: 'ครม.อนุมัติ "วาฬสีน้ำเงิน" เป็นสัตว์ป่าสงวน ป้องกันไม่ให้สูญพันธุ์',
      imageUrl: 'assets/images/news2.jpg',
      date: '28 กุมภาพันธ์ 2026',
      category: 'ความรู้',
      views: 1250,
      shares: 42,
      content: 'รายละเอียดข่า...',
    ),
    NewsArticle(
      title: 'ขสป.คลองแสง เผยภาพความสำเร็จ พบสัตว์ป่าสงวนปรากฏตัว',
      imageUrl: 'assets/images/new3.jpg',
      date: '28 กุมภาพันธ์ 2026',
      category: 'ความรู้',
      views: 1250,
      shares: 42,
      content: 'นายสุขี บุญสร้าง ผู้อำนวยการสำนักบริหารพื้นที่อนุรักษ์  เปิดเผยภาพบันทึกเหตุการณ์สำคัญ ณ บริเวณหน้าหน่วยพิทักษ์ป่าห้วยถ้ำจันทน์ เขตรักษาพันธุ์สัตว์ป่าคลองแสง จ.สุราษฎร์ธานี โดยปรากฏภาพสัตว์ป่าสงวนออกมาใช้ชีวิตและหากินตามธรรมชาติอย่างใกล้ชิด สะท้อนถึงดัชนีชี้วัดความอุดมสมบูรณ์ของทรัพยากรธรรมชาติในพื้นที่',
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
          // หัวข้อ "ข่าวสารสัตว์ป่า"
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "ข่าวสารสัตว์ป่า",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black),
            ),
          ),
          
          // รายการข่าว
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 100), // เว้นให้แถบล่าง
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return GestureDetector(
                  onTap: () {
                    // กดแล้วไปหน้ารายละเอียดข่าว
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(article: news),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F7), // สีพื้นหลังอมชมพูอ่อนๆ ตามดีไซน์
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        // รูปภาพด้านซ้าย
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            news.imageUrl,
                            width: 140,
                            height: 120,
                            fit: BoxFit.cover,
                            // ถ้าหารูปไม่เจอให้โชว์กล่องสีเทาแทนไปก่อน
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 140, height: 120, color: Colors.grey,
                              child: const Icon(Icons.image, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // ข้อความด้านขวา
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                            child: Text(
                              news.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
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
      // --- แถบเมนูด้านล่าง (นำมาจากหน้าประวัติ) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        margin: const EdgeInsets.only(top: 30),
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2E5B2C),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home, color: Colors.white, size: 35), onPressed: () {
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
              }),
              const SizedBox(width: 40),
              IconButton(icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// หน้าจอที่ 2: หน้ารายละเอียดข่าว (News Detail Screen)
// =========================================================
class NewsDetailScreen extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailScreen({super.key, required this.article});

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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100), // เว้นให้แถบล่าง
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // หัวข้อข่าว
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  article.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                ),
              ),
              const SizedBox(height: 12),
              
              // ข้อมูลสถิติ (หมวดหมู่ - วันที่ - ยอดวิว - ยอดแชร์)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${article.category} - ${article.date} - ',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const Icon(Icons.visibility, color: Colors.grey, size: 16),
                  Text(' ${article.views} - ', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const Icon(Icons.share, color: Colors.grey, size: 16),
                  Text(' ${article.shares}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
              
              // รูปภาพข่าว
              Image.asset(
                article.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250, width: double.infinity, color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              
              // เนื้อหาข่าว
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    article.content,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF4A4A4A), height: 1.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // --- แถบเมนูด้านล่าง (ให้โชว์ในหน้ารายละเอียดด้วยตามดีไซน์) ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        width: 75,
        margin: const EdgeInsets.only(top: 30),
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2E5B2C),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home, color: Colors.white, size: 35), onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                  );
              }),
              const SizedBox(width: 40),
              IconButton(icon: const Icon(Icons.account_circle, color: Colors.white, size: 35), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}