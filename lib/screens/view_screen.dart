import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/webtoon.dart';
import 'home_screen.dart';

class ViewScreen extends StatelessWidget {
  final Webtoon webtoon;

  const ViewScreen({super.key, required this.webtoon});

  Future<Uint8List> fetchImage(String scriptDescription) async {
    // The OPENAI API key
    const String openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Authorization': 'Bearer $openAiApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "dall-e-2",
        'prompt': scriptDescription,
        "n": 1,
        "size": "256x256",
        // "size": "512x512",
        "response_format": "b64_json"
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // Extract the base64 data from responseBody
      String base64Data = responseBody['data'][0]['b64_json'];
      // Write the base64 data to a file
      // String filePath = await writeBase64AsFile(base64Data);
      return base64Decode(base64Data);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<String> writeBase64AsFile(String base64Data) async {
    final bytes = base64Decode(base64Data);
    final file = File('./${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let Us Webtoon',
            style: Theme.of(context).textTheme.headlineMedium),
        automaticallyImplyLeading: true, // This will add the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Navigate back to the HomeScreen with the Webtoon array
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                      webtoons: [webtoon]), // Pass the Webtoon array here
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ListView(
            children: [
              Text(
                webtoon.series,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0), // Adds space between text elements
              Text(
                'Arc: ${webtoon.arc}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0), // Adds space between text elements
              Text(
                'Episode: ${webtoon.episode}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8.0), // Adds space between text elements
              Text(
                webtoon.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 16.0), // Adds space before the list starts
              ...webtoon.script.map((script) {
                return FutureBuilder(
                  future: fetchImage(script.description),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      // final imagePath = snapshot.data as String;
                      // final imageBytes = File(imagePath).readAsBytesSync();
                      final imageBytes = snapshot.data as Uint8List;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Adds space between cards
                        child: Column(
                          children: [
                            Card(
                              // Wraps image in a Card for a polished look
                              elevation: 2.0,
                              child: Image.memory(imageBytes),
                            ),
                            const SizedBox(
                                height:
                                    8.0), // Adds space between image and text
                            Text(
                              script.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16.0), // Adjust font size as needed
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
