import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ 1. นำเข้า firebase_core
import 'firebase_options.dart';

import 'screens/auth/loading_screen.dart'; 

// ✅ 2. เปลี่ยน main ให้เป็น async
void main() async { 
  // ✅ 3. สั่งให้ Flutter เตรียมตัวให้พร้อมก่อนเรียกใช้ปลั๊กอิน
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // ✅ 4. สั่งเริ่มต้นการทำงานของ Firebase
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
      home: const LoadingScreen(), 
    );
  }
}