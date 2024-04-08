import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_us_webtoon/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

// Get a reference to the Auth service
var _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  // Declare the controllers for the email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Declare the variables for the form validation and the loading indicator
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Define the methods for creating and signing in a user with email and password
  Future<void> _createUser() async {
    // Validate the form inputs
    if (_formKey.currentState!.validate()) {
      // Show the loading indicator
      setState(() {
        _loading = true;
      });
      try {
        // Create a new user with the email and password
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle the error and show a snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
      } finally {
        // Hide the loading indicator
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signInUser() async {
    // Validate the form inputs
    if (_formKey.currentState!.validate()) {
      // Show the loading indicator
      setState(() {
        _loading = true;
      });
      try {
        // Sign in the user with the email and password
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navigate to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Handle the error and show a snackbar message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message!)),
        );
      } finally {
        // Hide the loading indicator
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Define the method for signing out the user
  Future<void> _signOutUser() async {
    // Sign out the user from Firebase
    await _auth.signOut();
    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let Us Webtoon',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium, // Customize label text color
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.tealAccent), // Customize border color),
                      )),
                  validator: (value) {
                    // Validate the email input
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // Password field
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .titleMedium, // Customize label text color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.tealAccent), // Customize border color),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    // Validate the password input
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Please enter a password with at least 6 characters';
                    }
                    return null;
                  },
                ),
                // Login and sign up buttons
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _createUser,
                      child: const Text('Sign Up'),
                    ),
                    ElevatedButton(
                      onPressed: _signInUser,
                      child: const Text('Log In'),
                    ),
                  ],
                ),
                // Loading indicator
                if (_loading) const SizedBox(height: 16.0),
                if (_loading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
