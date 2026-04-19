import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // สร้าง Controllers สำหรับรับค่าจากช่องกรอกข้อมูล
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // ตัวแปรซ่อน/แสดงรหัสผ่าน
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // ตัวแปรจัดการภาษา
  bool _isThai = true;

  // ตัวแปรเช็คสถานะการโหลด
  bool _isLoading = false;

  //ฟังก์ชันสมัครสมาชิกด้วย Firebase
  Future<void> _register() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // เช็คว่ามีช่องไหนว่าง
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showIncompleteDialog();
      return;
    }

    //เช็คว่ารหัสผ่านทั้งสองช่องตรงกันไหม
    if (password != confirmPassword) {
      _showErrorDialog(_isThai ? "รหัสผ่านไม่ตรงกัน" : "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true; // เริ่มหมุน Loading
    });

    try {
      //สร้างบัญชีผู้ใช้ใน Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //อัปเดตชื่อใน Auth
      await userCredential.user?.updateDisplayName("$firstName $lastName");

      // บันทึกข้อมูลส่วนตัวและ Role ลงใน Cloud Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid) // ใช้ UID จาก Auth เป็นรหัสอ้างอิง
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'name': "$firstName $lastName", // ดึงไปโชว์ในหน้า Profile
        'email': email,
        'role': 'user', //
        'createdAt': FieldValue.serverTimestamp(), // เก็บเวลาที่สมัคร
      });

      if (!mounted) return; 

      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog();

    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // 📌 เช็ค mounted
      
      setState(() {
        _isLoading = false;
      });
      // ดักจับ Error จาก Firebase
      String errorMessage = "เกิดข้อผิดพลาดในการสมัครสมาชิก";
      if (e.code == 'weak-password') {
        errorMessage = _isThai ? 'รหัสผ่านอ่อนเกินไป (ต้อง 6 ตัวขึ้นไป)' : 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = _isThai ? 'อีเมลนี้ถูกใช้งานแล้ว' : 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = _isThai ? 'รูปแบบอีเมลไม่ถูกต้อง' : 'The email address is badly formatted.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      if (!mounted) return; // 📌 เช็ค mounted
      
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  // ป๊อปอัพแสดง Error ทั่วไป
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF9E9E9E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            _isThai ? "แจ้งเตือน" : "Alert", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
          content: Text(message, style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_isThai ? "ตกลง" : "OK", style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ป๊อปอัพข้อมูลไม่ครบถ้วน
  void _showIncompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF9E9E9E), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isThai ? 'กรุณากรอกข้อมูล\nให้ครบถ้วน' : 'Please fill in\nall fields',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isThai 
                    ? 'กรุณากรอกรายละเอียดข้อมูลของ\nท่านให้ครบถ้วน' 
                    : 'Please complete all your\ninformation details.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); 
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
                      child: Text(
                        _isThai ? 'ลองอีกครั้ง' : 'Try Again',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        _isThai ? 'ปิด' : 'Close',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  // ป๊อปอัพสมัครสมาชิกสำเร็จ
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF9E9E9E), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isThai ? 'สมัครสมาชิกสำเร็จ' : 'Sign Up Success',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 60,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _isThai 
                    ? 'คุณสามารถล็อกอินสมาชิกได้แล้วที่\nหน้าล็อกอิน' 
                    : 'You can now log in at\nthe login page.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey.shade600,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        _isThai ? 'ล็อกอิน' : 'Log in',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        _isThai ? 'ปิด' : 'Close',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 140),
                    
                    Text(
                      _isThai ? 'สมัครบัญชีผู้ใช้' : 'Register Account',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(
                      controller: _firstNameController,
                      label: _isThai ? 'ชื่อจริง' : 'First Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _lastNameController,
                      label: _isThai ? 'นามสกุล' : 'Last Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _emailController,
                      label: _isThai ? 'อีเมล' : 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _passwordController,
                      label: _isThai ? 'รหัสผ่าน' : 'Password',
                      obscureText: _obscurePassword,
                      isPassword: true,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: _isThai ? 'ยืนยันรหัสผ่าน' : 'Confirm Password',
                      obscureText: _obscureConfirmPassword,
                      isPassword: true,
                      onTogglePassword: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9E9E9E), 
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : Text(
                                _isThai ? 'สมัครบัญชี' : 'Register',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        _isThai ? 'กลับไปหน้าล็อคอิน' : 'Back to login',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    bool isPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextFormField(
      controller: controller, 
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onTogglePassword,
              )
            : null,
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
    );
  }
}