import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoadingScreen extends StatefulWidget {
  final Widget? nextPage; // 
  const LoadingScreen({Key? key, this.nextPage}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // ✅ 2. ปรับการเปลี่ยนหน้า: ถ้ามี nextPage ให้ไปหน้านั้น ถ้าไม่มีให้ไป Login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => widget.nextPage ?? const LoginScreen(),
            ),
          );
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: _animation.value, 
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'KuenPa',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003319),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 250,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 250 * _animation.value, 
                    decoration: BoxDecoration(
                      color: const Color(0xFF2CA85A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}