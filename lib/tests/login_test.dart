import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_us_webtoon/screens/login_screen.dart';

void main() {
  group('LoginScreen Tests', () {
    // Create fake user credentials for testing
    const String testEmail = 'test@example.com';
    const String testPassword = 'password123';

    // Initialize the LoginScreen and its state
    late LoginScreen loginScreen;
    late _LoginScreenState loginScreenState;

    setUp(() {
      loginScreen = const LoginScreen();
      loginScreenState = loginScreen.createState();
    });

    test('Create user with valid email and password', () async {
      // Simulate user input for email and password
      loginScreenState._emailController.text = testEmail;
      loginScreenState._passwordController.text = testPassword;

      // Call the _createUser method
      await loginScreenState._createUser();

      // Check if the current user is not null (user created successfully)
      expect(FirebaseAuth.instance.currentUser, isNotNull);
      expect(FirebaseAuth.instance.currentUser!.email, equals(testEmail));

      // Clean up: sign out the user after the test
      await FirebaseAuth.instance.signOut();
    });

    test('Sign in user with valid email and password', () async {
      // Simulate user input for email and password
      loginScreenState._emailController.text = testEmail;
      loginScreenState._passwordController.text = testPassword;

      // Call the _signInUser method
      await loginScreenState._signInUser();

      // Check if the current user is not null (user signed in successfully)
      expect(FirebaseAuth.instance.currentUser, isNotNull);
      expect(FirebaseAuth.instance.currentUser!.email, equals(testEmail));

      // Clean up: sign out the user after the test
      await FirebaseAuth.instance.signOut();
    });
  });
}
