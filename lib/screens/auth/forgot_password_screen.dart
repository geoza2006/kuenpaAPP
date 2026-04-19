import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _sendResetLink() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      // แจ้งเตือนถ้าไม่ได้กรอกอีเมล
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกอีเมลของคุณ')),
      );
      return;
    }

    // สมมติว่าถ้าผู้ใช้ไม่ได้พิมพ์ตัว "@" จะถือว่าไม่มีอีเมลนี้ในระบบ
    bool isEmailFound = email.contains('@');

    if (!isEmailFound) {
      // ถ้าไม่พบอีเมล ให้เรียกแสดงป๊อปอัพแจ้งเตือน
      _showErrorDialog();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ส่งลิงก์สำเร็จ'),
          content: Text('เราได้ส่งลิงก์รีเซ็ตรหัสผ่านไปที่\n$email แล้ว\nกรุณาตรวจสอบกล่องข้อความของคุณ'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Dialog
                Navigator.pop(context); // กลับไปหน้า Login
              },
              child: const Text('ตกลง', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    }
  }

  //ฟังก์ชันสร้างป๊อปอัพ "ไม่พบอีเมล"
  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // บังคับให้กดปุ่มเท่านั้นถึงจะปิดป๊อปอัพได้
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF9E9E9E), // สีเทา
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // ขอบมน
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ให้กล่องสูงพอดีกับเนื้อหา
              children: [
                // หัวข้อ
                const Text(
                  'ไม่พบอีเมล!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // ข้อความอธิบาย
                const Text(
                  'กรุณาตรวจสอบอีเมลของท่านให้\nถูกต้องแล้วกด ลองอีกครั้ง หรือกดปุ่ม\nออกจากแอพ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                
                // แถวของปุ่มกด
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ปุ่ม ลองอีกครั้ง
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // ปิดป๊อปอัพ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey.shade600,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    
                    // ปุ่ม ออกจากแอพ
                    OutlinedButton(
                      onPressed: () {
                        SystemNavigator.pop(); // คำสั่งออกจากแอพพลิเคชัน
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5), // เส้นขอบสีขาว
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'ออกจากแอพ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose(); // คืนหน่วยความจำเมื่อปิดหน้า
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // โลโก้ KuenPa
                Image.asset('assets/images/logo.png', height: 150),

                // ไอคอนแม่กุญแจใบไม้
                // Image.asset('assets/images/lock_leaf.png', height: 100),
                
                Icon(
                  Icons.lock_reset_rounded,
                  size: 100,
                  color: Colors.green.shade800,
                ),
                const SizedBox(height: 24),

                // ข้อความหัวข้อ
                const Text(
                  'ลืมรหัสผ่าน ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // ข้อความอธิบาย
                const Text(
                  'กรอกอีเมลของคุณเพื่อยืนยัน\nการรับลิงก์รีเซ็ตรหัสผ่านใหม่',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // ช่องกรอกอีเมล
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
                const SizedBox(height: 30),

                // ปุ่มส่งลิงก์
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _sendResetLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9E9E9E), // สีเทา
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ส่งลิงก์',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ปุ่มกลับไปหน้าล็อคอิน
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // กดย้อนกลับ
                  },
                  child: const Text(
                    'กลับไปหน้าล็อคอิน',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}