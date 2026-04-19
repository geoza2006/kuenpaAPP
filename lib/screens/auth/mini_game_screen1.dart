import 'package:flutter/material.dart';
import 'dart:async';

enum GameState { playing, correct, wrong }

class MiniGameScreen1 extends StatefulWidget {
  const MiniGameScreen1({super.key});

  @override
  State<MiniGameScreen1> createState() => _MiniGameScreenState();
}

class _MiniGameScreenState extends State<MiniGameScreen1> {
  // สถานะเริ่มต้นกำลังเล่น
  GameState _gameState = GameState.playing;

  // ข้อมูลจำลองของคำถาม
  final String questionImage = 'assets/images/tapir.jpg';
  final String correctAnswer = 'สมเสร็จ';
  
  // ตัวเลือกและสีของปุ่ม
  final List<Map<String, dynamic>> options = [
    {'text': 'สมัน', 'color': const Color(0xFFFC8F93)},    // สีชมพูอมแดง
    {'text': 'กระซู่', 'color': const Color(0xFF90F585)},    // สีเขียวอ่อน
    {'text': 'เลียงผา', 'color': const Color(0xFFFBFD89)},  // สีเหลืองอ่อน
    {'text': 'สมเสร็จ', 'color': const Color(0xFFFF8BFF)}, // สีม่วงชมพู
  ];

  // ฟังก์ชันเช็คคำตอบ
  void _checkAnswer(String selectedAnswer) {
    if (_gameState != GameState.playing) return; // ป้องกันการกดซ้ำ

    setState(() {
      if (selectedAnswer == correctAnswer) {
        _gameState = GameState.correct;
      } else {
        _gameState = GameState.wrong;
      }
    });

    // หน่วงเวลา 3 วินาทีแล้วกลับมาหน้าเล่นเกมต่อ
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _gameState = GameState.playing;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // เปลี่ยนสีพื้นหลังตามสถานะ
      backgroundColor: _gameState == GameState.correct
          ? const Color(0xFF03CD00) // สีเขียวสว่างตอนตอบถูก
          : _gameState == GameState.wrong
              ? const Color(0xFFFF4101) // สีแดง/ส้มตอนตอบผิด
              : Colors.white,
      appBar: _gameState == GameState.playing
          ? AppBar(
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
            )
          : null, // ซ่อน AppBar ตอนโชว์ถูก/ผิด
      
      body: _buildBody(),
      
      // แถบเมนูด้านล่างปรับเปลี่ยนสีตามสถานะเกม
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    if (_gameState == GameState.correct) {
      // หน้าตอบถูก
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Correct", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            Icon(Icons.check, size: 150, color: Colors.white), // ใช้ Icon เช็คถูก
          ],
        ),
      );
    } else if (_gameState == GameState.wrong) {
      // หน้าตอบผิด
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wrong", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),
            Icon(Icons.close, size: 150, color: Colors.white), // ใช้ Icon กากบาท
          ],
        ),
      );
    }

    // หน้าเล่นเกมปกติ
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // รูปภาพคำถาม
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              questionImage,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220, width: double.infinity, color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // คำถาม
          const Text(
            "นี่คือสัตว์สงวนชนิดใด ?",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 24),
          
          // ปุ่มตัวเลือก
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildAnswerButton(options[0]),
                      const SizedBox(width: 10),
                      _buildAnswerButton(options[1]),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      _buildAnswerButton(options[2]),
                      const SizedBox(width: 10),
                      _buildAnswerButton(options[3]),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // เว้นที่ให้ Bottom NavBar
              ],
            ),
          ),
        ],
      ),
    );
  }

  // สร้างปุ่มตัวเลือก
  Widget _buildAnswerButton(Map<String, dynamic> option) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _checkAnswer(option['text']),
        child: Container(
          decoration: BoxDecoration(
            color: option['color'],
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            option['text'],
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    Color fabBgColor;
    Color iconColor;
    Color borderColor = Colors.transparent;

    if (_gameState == GameState.playing) {
      fabBgColor = const Color(0xFF2E5B2C); // พื้นเขียวเข้ม
      iconColor = Colors.white;            // ไอคอนขาว
      borderColor = Colors.white;          // ขอบขาว
    } else if (_gameState == GameState.correct) {
      fabBgColor = Colors.white;           // พื้นขาว
      iconColor = const Color(0xFF03CD00); // ไอคอนเขียว
      borderColor = const Color(0xFF03CD00); // ขอบเขียว
    } else {
      fabBgColor = Colors.white;           // พื้นขาว
      iconColor = const Color(0xFFFF4101); // ไอคอนแดง
      borderColor = const Color(0xFFFF4101); // ขอบแดง
    }

    return Container(
      height: 75, width: 75, margin: const EdgeInsets.only(top: 30),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: fabBgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: borderColor, width: 4), // สีขอบเปลี่ยนตามสถานะ
        ),
        child: Icon(Icons.camera_alt, color: iconColor, size: 35),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    Color navBgColor;
    Color iconColor;

    if (_gameState == GameState.playing) {
      navBgColor = const Color(0xFF2E5B2C);
      iconColor = Colors.white;
    } else {
      navBgColor = Colors.white;
      iconColor = _gameState == GameState.correct ? const Color(0xFF03CD00) : const Color(0xFFFF4101);
    }

    return BottomAppBar(
      color: navBgColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: _gameState == GameState.playing ? 8 : 0, // ซ่อนเงาตอนโชว์ถูกผิด
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home, color: iconColor, size: 35), onPressed: () {}),
            const SizedBox(width: 40),
            IconButton(icon: Icon(Icons.account_circle, color: iconColor, size: 35), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}