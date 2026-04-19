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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator(color: Colors.green)),
            );
          }

          if (snapshot.hasData) {
            return const LoadingScreen(nextPage: HomeScreen()); 
          }
          return const LoadingScreen(nextPage: LoginScreen());
        },
      ),
    );
  }
}