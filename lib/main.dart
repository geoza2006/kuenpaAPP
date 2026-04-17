import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';

import 'screens/auth/loading_screen.dart'; 

void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // 📌 3. ใช้ StreamBuilder ครอบไว้เพื่อเช็คว่าล็อกอินอยู่หรือไม่
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. ระหว่างรอ Firebase เช็คข้อมูล (ปกติจะเร็วมาก) 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          }

          //ถ้า Firebase พบว่า "เคยล็อกอินไว้แล้ว"
          // ให้เรียกหน้า LoadingScreen แล้วแอบส่ง HomeScreen() ไปรอไว้
          if (snapshot.hasData) {
            return const LoadingScreen(nextPage: HomeScreen()); 
          }

          //ถ้า "ยังไม่ได้ล็อกอิน" หรือเพิ่งโหลดแอปครั้งแรก
          // ให้เรียกหน้า LoadingScreen แล้วส่ง LoginScreen() ไปรอไว้
          return const LoadingScreen(nextPage: LoginScreen());
        },
      ),
    );
  }
}