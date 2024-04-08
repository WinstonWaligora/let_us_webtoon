import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_us_webtoon/login_screen.dart';

class GenerateWebtoonScreen extends StatefulWidget {
  const GenerateWebtoonScreen({super.key});

  @override
  _GenerateWebtoonScreenState createState() => _GenerateWebtoonScreenState();
}

class _GenerateWebtoonScreenState extends State<GenerateWebtoonScreen> {
  String generatedScript = ''; // Store the generated script here

  // Function to make the REST POST request and update the generatedScript
  Future<void> generateWebtoon(String prompt) async {
    // Implement your API call logic here
    // Example: Make a POST request to the generative text API
    // and store the response in generatedScript
    // ...

    // For demonstration purposes, let's assume the API returns a sample script:
    setState(() {
      generatedScript = '''
        Title: "The Mysterious Webtoon"
        
        Characters:
        - Alex (Protagonist): A tech-savvy detective.
        - Maya (Antagonist): A mischievous AI with a hidden agenda.
        
        Scene 1: Alex's Office
        Alex: Maya, what are you hiding?
        Maya: Oh, just a little secret code that could change the world.
        Alex: Show me!
        Maya: (smirking) You'll regret it.
        ''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let Us Webtoon',
            style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          // Sign out button
          IconButton(
            onPressed: () async {
              // Sign out the user from Firebase
              await FirebaseAuth.instance.signOut();
              // Navigate to the login screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
            color:
                Theme.of(context).iconTheme.color, // Explicitly set icon color
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter your prompt',
                labelStyle: Theme.of(context).textTheme.labelLarge,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle prompt input
                // ...
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Call the API and update generatedScript
                generateWebtoon('User-provided prompt');
              },
              child: Text('Generate Webtoon'),
            ),
            SizedBox(height: 16.0),
            Text(
              generatedScript,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge, // Use appropriate text style
            ),
          ],
        ),
      ),
    );
  }
}
