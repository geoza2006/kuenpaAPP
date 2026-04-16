import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';
import 'loading_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ตัวแปรซ่อน/แสดงรหัสผ่าน
  bool _obscurePassword = true;
  // ตัวแปรจดจำฉัน
  bool _rememberMe = false;
  // ตัวแปรจัดการภาษา (true = ไทย, false = อังกฤษ)
  bool _isThai = true;

  // ฟังก์ชันแสดงป๊อปอัพเมื่อรหัสผ่านหรืออีเมลไม่ถูกต้อง
  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // กดพื้นที่ว่างเพื่อปิดได้
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // มุมโค้งมน
          ),
          backgroundColor: const Color(0xFF9E9E9E), // สีพื้นหลังเทาตามแบบ
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ให้กรอบพอดีกับเนื้อหา
              children: [
                const Text(
                  'รหัสผ่านหรืออีเมล\nไม่ถูกต้อง',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'กรุณากรอกข้อมูลของท่านให้ถูก\nต้อง หากยังไม่มีบัญชีกด\nสมัครบัญชี หรือ ลืมรหัสผ่าน\nกดที่ปุ่มลืมรหัสผ่าน',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ปุ่ม "ลองอีกครั้ง"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิดป๊อปอัพ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // พื้นหลังขาว
                        foregroundColor: const Color(0xFF9E9E9E), // ตัวหนังสือเทา
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'ลองอีกครั้ง',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ปุ่ม "ปิด"
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิดป๊อปอัพ
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white, // ตัวหนังสือขาว
                        side: const BorderSide(color: Colors.white, width: 1.5), // กรอบขาว
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text(
                        'ปิด',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ส่วนเนื้อหาหลัก
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // โลโก้ (เปลี่ยนที่อยู่ไฟล์รูปของคุณตรงนี้)
                    Image.asset('assets/images/logo.png', height: 200),
                    
                    // ปล่อยกล่องสี่เหลี่ยมไว้แทนรูปชั่วคราว
                    // ช่องกรอกชื่อผู้ใช้ (หรือ Email)
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: _isThai ? 'กรุณากรอกชื่อผู้ใช้' : 'Username',
                        prefixIcon: const Icon(Icons.person, color: Colors.grey),
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
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ช่องกรอกรหัสผ่าน
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: _isThai ? 'รหัสผ่าน' : 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                      ),
                    ),
                    const SizedBox(height: 10),

                    // จดจำฉัน & ลืมรหัสผ่าน
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text(_isThai ? 'จดจำฉัน' : 'Remember me', 
                              style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          child: Text(
                            _isThai ? 'ลืมรหัสผ่าน ?' : 'Forgot password?',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ปุ่มเข้าสู่ระบบ
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // 1. สั่งให้ Firebase ทำการล็อคอิน
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text.trim(), // ดึงค่าจากช่องอีเมล
                              password: _passwordController.text.trim(), // ดึงค่าจากช่องรหัสผ่าน
                            );
                            
                            // 2. ถ้าล็อคอินสำเร็จ จะมาทำงานตรงนี้ (ไปหน้า Home ทันที)
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoadingScreen(nextPage: HomeScreen(),
                                ),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            // 3. ถ้าล็อคอินไม่สำเร็จ (รหัสผิด หรือ อีเมลไม่ถูกต้อง) จะเด้งมาตรงนี้
                            print('Login Failed: ${e.code}'); // พิมพ์บอกใน Console ว่าเออเร่ออะไร
                            _showErrorDialog(); // แสดงป๊อปอัพแจ้งเตือน
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300, 
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isThai ? 'เข้าสู่ระบบ' : 'Login',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ลิงก์ไปหน้าสมัครสมาชิก
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isThai ? 'ยังไม่มีบัญชี? ' : "Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            // นำทางไปหน้า Register
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(), // ชื่อคลาสหน้าสมัครสมาชิกของคุณ
                              ),
                            );
                          },
                          child: Text(
                            _isThai ? 'สมัครตอนนี้เลย' : 'Register now',
                            style: const TextStyle(
                              color: Color(0xFF2BA879), // สีเขียว
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ปุ่มเปลี่ยนภาษามุมขวาบน
            Positioned(
              top: 16,
              right: 16,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isThai = !_isThai;
                  });
                },
                icon: const Icon(Icons.language, color: Colors.grey),
                label: Text(
                  _isThai ? 'EN' : 'TH',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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