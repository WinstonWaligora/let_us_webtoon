import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:let_us_webtoon/screens/generate_webtoon.dart';
import 'package:let_us_webtoon/models/webtoon.dart';

void main() {
  group('GenerateWebtoonScreen Tests', () {
    // Initialize the GenerateWebtoonScreen
    late GenerateWebtoonScreen generateWebtoonScreen;
    late _GenerateWebtoonScreenState generateWebtoonScreenState;

    setUp(() {
      generateWebtoonScreen = GenerateWebtoonScreen();
      generateWebtoonScreenState = generateWebtoonScreen.createState();
    });

    testWidgets('Generate webtoon with valid prompt', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(MaterialApp(home: generateWebtoonScreen));

      // Simulate user input for the prompt
      generateWebtoonScreenState.prompt = 'A thrilling adventure in space.';

      // Call the generateWebtoon method
      await generateWebtoonScreenState.generateWebtoon(generateWebtoonScreenState.prompt);

      // Verify that the generatedScript is updated
      expect(generateWebtoonScreenState.generatedScript, isNotEmpty);

      // Verify that a new Webtoon object is created
      expect(generateWebtoonScreenState.newWebtoonEpisode, isInstanceOf<Webtoon>());

      // Verify that the new Webtoon object has the required fields filled
      expect(generateWebtoonScreenState.newWebtoonEpisode.series, isNotEmpty);
      expect(generateWebtoonScreenState.newWebtoonEpisode.arc, isNotEmpty);
      expect(generateWebtoonScreenState.newWebtoonEpisode.episode, isNonZero);
      expect(generateWebtoonScreenState.newWebtoonEpisode.title, isNotEmpty);
      expect(generateWebtoonScreenState.newWebtoonEpisode.description, isNotEmpty);
      expect(generateWebtoonScreenState.newWebtoonEpisode.characters, isNotEmpty);
      expect(generateWebtoonScreenState.newWebtoonEpisode.script, isNotEmpty);
    });
  });
}
