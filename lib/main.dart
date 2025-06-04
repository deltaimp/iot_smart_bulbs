import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/views/onboarding/onboarding_screen.dart';
import 'package:get/get.dart';
import 'business_logic/controllers/bulb_controller.dart';
import 'business_logic/controllers/loading_controller.dart';

void main() {
  Get.put(LoadingController());
  Get.put(BulbController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Bulb Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black45,
        primaryColor: Colors.tealAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white, // testo bianco
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        dividerColor: Colors.white24,
      ),

      home: OnboardingScreen(),
    );
  }
}