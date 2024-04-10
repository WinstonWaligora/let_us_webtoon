import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_us_webtoon/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    // The OPENAI API key
    const String openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
    const prompt = 'Write a short story about a mysterious island.';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openAiApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You write webtoon play scripts in JSON given my description. The JSON struct should follow {\"number\": 1, \"title\": \"A New World\", \"description\": \"comedy fantasy isekai, rags to riches becoming overpowered\", \"characters\": [\"Johny\", \"Suzzy\"], \"script\": [\"Suzzy: Help!\", \"Johny: I'll save you!\", \"*Woosh*\", \"Johny: Where am I?\"]}"
          },
          {
            "role": "user",
            "content":
                "comedy fantasy isekai, rags to riches becoming overpowered"
          }
        ],
        // "max_tokens": 50,
        "response_format": {"type": "json_object"}
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final generatedText = responseBody['choices'][0]['message']['content'];
      print('Error: ${responseBody}');
      setState(() {
        generatedScript = generatedText;
      });
    } else {
      generatedScript = response.reasonPhrase!;
      print('Error: ${response.reasonPhrase}');
    }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter your prompt',
                  labelStyle: Theme.of(context).textTheme.labelLarge,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Handle prompt input
                  // ...
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Call the API and update generatedScript
                  generateWebtoon('User-provided prompt');
                },
                child: const Text('Generate Webtoon'),
              ),
              const SizedBox(height: 16.0),
              Text(
                generatedScript,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge, // Use appropriate text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
