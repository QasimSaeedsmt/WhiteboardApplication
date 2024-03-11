import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whiteboard/ui/screens/auth/login_page.dart';

import '../../../controllers/auth_controller.dart';
import '../whiteboard/whiteboard_screen.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = Get.find();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _authController.createUser(
                  emailController.text,
                  passwordController.text,
                );
                if (_authController.user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WhiteboardPage()));
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text("Login here"))
          ],
        ),
      ),
    );
  }
}
