import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart';

// 📌 1. เพิ่มการ Import หน้า ProfileScreen (ตรวจสอบ Path ให้ถูกต้อง)
import 'screens/auth/profile_screen.dart'; 

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
      // 📌 2. เปลี่ยนตรงนี้จาก HomeScreen() ให้เป็น ProfileScreen()
      home: const ProfileScreen(), 
    );
  }
}