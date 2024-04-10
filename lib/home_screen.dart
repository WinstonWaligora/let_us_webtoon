import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:let_us_webtoon/generate_webtoon.dart';
import 'package:let_us_webtoon/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;

    // Sample list of webtoon names (replace with your actual data)
    final List<String> webtoonNames = [
      'Fantasy Webtoon A',
      'Fantasy Webtoon B',
      'Fantasy Webtoon C'
      // Add more webtoon names as needed
    ];

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display user's email
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Logged in as ${user?.email ?? 'Guest'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          // Plus sign for generating a new webtoon
          GestureDetector(
            onTap: () {
              // Navigate to GenerateWebtoonScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const GenerateWebtoonScreen()),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 8.0),
                Text('Generate New Webtoon'),
              ],
            ),
          ),
          // List of webtoon names
          Expanded(
            child: ListView.builder(
              itemCount: webtoonNames.length,
              itemBuilder: (context, index) {
                final webtoonName = webtoonNames[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.amber, // Customize border color
                      ),
                      borderRadius:
                          BorderRadius.circular(8.0), // Customize border radius
                    ),
                    title: Text(
                      webtoonName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // View webtoon icon
                        IconButton(
                          onPressed: () {
                            // Navigate to ViewWebtoonScreen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Explicitly set icon color
                        ),
                        // Generate next episode icon
                        IconButton(
                          onPressed: () {
                            // Navigate to GenerateWebtoonScreen with webtoon data
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          icon: const Icon(Icons.create),
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Explicitly set icon color
                        ),
                        // Delete webtoon series icon
                        IconButton(
                          onPressed: () {
                            // Show confirmation popup for deletion
                            // Implement your confirmation logic here
                          },
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context)
                              .iconTheme
                              .color, // Explicitly set icon color
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
