import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whiteboard/ui/screens/auth/signup_screen.dart';
import 'package:whiteboard/ui/screens/whiteboard/whiteboard_screen.dart';

import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Error : $e");
  }
  runApp(const WhiteboardApp());
  Get.put(AuthController()); // Initialize the AuthController
}

class WhiteboardApp extends StatelessWidget {
  const WhiteboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = AuthController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authController.user == null ? SignUpPage() : WhiteboardPage(),
    );
  }
}
