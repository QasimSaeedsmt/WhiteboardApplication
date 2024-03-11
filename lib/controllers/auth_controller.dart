import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:whiteboard/ui/screens/whiteboard/whiteboard_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> _firebaseUser = Rx<User?>(null);

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _auth.authStateChanges().firstWhere((user) => user != null);

      // Navigate to WhiteboardPage after successful signup
      Get.to(() => WhiteboardPage());
    } catch (error) {
      Get.snackbar('Error creating account', error.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error during login", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
