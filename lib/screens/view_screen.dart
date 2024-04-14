import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/webtoon.dart';

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
        title: Text(webtoon.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Arc: ${webtoon.arc}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Episode: ${webtoon.episode}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            ...webtoon.script.map((script) {
              return FutureBuilder(
                future: fetchImage(script.description),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    // final imagePath = snapshot.data as String;
                    // final imageBytes = File(imagePath).readAsBytesSync();
                    final imageBytes = snapshot.data as Uint8List;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.memory(imageBytes),
                        Text(script.text),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
