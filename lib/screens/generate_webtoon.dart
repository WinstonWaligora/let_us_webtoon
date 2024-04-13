import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:let_us_webtoon/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/script.dart';
import '../models/webtoon.dart';
import 'view_screen.dart';

class GenerateWebtoonScreen extends StatefulWidget {
  const GenerateWebtoonScreen({super.key});

  @override
  _GenerateWebtoonScreenState createState() => _GenerateWebtoonScreenState();
}

class _GenerateWebtoonScreenState extends State<GenerateWebtoonScreen> {
  String generatedScript = ''; // Store the generated script here
  String prompt = 'Be creative and make anything like.';

  // Function to make the REST POST request and update the generatedScript
  Future<void> generateWebtoon(String prompt) async {
    // The sample webtoon structure
    var sampleWebtoon = Webtoon(
      series: '',
      arc: '',
      episode: 0,
      title: '',
      description: '',
      characters: [],
      script: [
        Script(
          scene: 0,
          description: '',
          text: '',
        ),
      ],
    );
    String sampleString = jsonEncode(sampleWebtoon);

    // The OPENAI API key
    const String openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');

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
            "content": "You are a helpful assistant. You will assist the user in creating a webtoon series. "
                "With each interaction, increment the episode number by one and advance the story arc. "
                "Once an arc concludes, begin a new arc. Provide a JSON object response with a consistent structure for easy parsing. "
                "The response should follow this structure: $sampleString"
                ". In the script text, label the character dialogue with only the first name of the character speaking. "
                "The script text may also contain immersive sensory details and onomatopoeia for a better reading experience. "
                "Ensure the script description includes the characters present in the scene and any characters speaking in the script text."
          },
          {"role": "user", "content": prompt}
        ],
        // "max_tokens": 50,
        "response_format": {"type": "json_object"}
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> parsedJson = jsonDecode(jsonDecode(response.body)['choices'][0]['message']['content']);
      Webtoon newWebtoonEpisode = Webtoon.fromJson(parsedJson);
      final responseBody = jsonDecode(response.body);
      final generatedText = responseBody['choices'][0]['message']['content'];
      // Use Navigator to push to the ViewWebtoonScreen with the newWebtoonEpisode
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ViewScreen(webtoon: newWebtoonEpisode),
        ),
      );
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
                onChanged: (input) {
                  // Handle prompt input
                  setState(() {
                    prompt = input;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Call the API and update generatedScript
                  generateWebtoon(prompt);
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
